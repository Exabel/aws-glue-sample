import io
import gzip
import sys
import boto3
from datetime import datetime

from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext

from awsglue.context import GlueContext
from awsglue.job import Job


def pandas_to_s3(df, client, bucket, key, separator):
    # write DF to string stream
    csv_buffer = io.StringIO()
    df.to_csv(csv_buffer, index=False, sep=separator)
    # reset stream position
    csv_buffer.seek(0)
    # create binary stream
    gz_buffer = io.BytesIO()
    # compress string stream using gzip
    with gzip.GzipFile(mode='w', fileobj=gz_buffer) as gz_file:
        gz_file.write(bytes(csv_buffer.getvalue(), 'utf-8'))
    # write stream to S3
    client.put_object(Bucket=bucket, Key=key, Body=gz_buffer.getvalue())


job_args = getResolvedOptions(sys.argv, ['JOB_NAME',
                                         'bucket',
                                         'data-key',
                                         'mapping-key',
                                         'mapping-filename',
                                         'output-key',
                                         'output-filename'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(job_args['JOB_NAME'], job_args)

s3_client = boto3.client('s3')

data = spark.read.csv(f"s3://{job_args['bucket']}/{job_args['data_key']}", header=True, inferSchema='true')

# find latest updated csv in input-key
mapping_response = s3_client.list_objects_v2(Bucket=job_args['bucket'],
                                             Prefix=job_args['mapping_key'])

# Get the key of the object with the highest LastModified date
latest_object = max(mapping_response['Contents'], key=lambda obj: obj['LastModified'])['Key']

if job_args['mapping_filename'] in latest_object:
  input_file = latest_object
else:
  print("Could not find any mapping files to process")
  exit(2)

# OBS! beware that separator in mapping files is ';'
mapping = spark.read.csv(f"s3://{job_args['bucket']}/{input_file}", header=True, inferSchema='true', sep=';')

# join with mapping file
data_mapped = data.join(mapping, (data.ticker == mapping.ticker) & (data.market == mapping.market))

# drop unnecessary columns
#data_mapped = data_mapped.drop('ticker', 'market')

# order columns
data_mapped = data_mapped.select('entity', 'date', 'signal1').orderBy('entity', 'date')

now = datetime.now()
date_time = now.strftime("%Y-%m-%d_%H:%M:%S")
destination = f"{job_args['output_key']}{date_time}"

# create destination folder with timestamp name
s3_client.put_object(Bucket=f"{job_args['bucket']}", Key=f"{destination}/")

destination_file = f"{destination}/{job_args['output_filename']}"

# write to destination file using pandas
pandas_to_s3(data_mapped.toPandas(), s3_client, job_args['bucket'], destination_file, ';')
