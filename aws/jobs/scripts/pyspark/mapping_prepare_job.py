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
                                         'input-key',
                                         'output-key',
                                         'output-filename'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(job_args['JOB_NAME'], job_args)

client = boto3.client('s3')

data = spark.read.format('csv').options(header='true').load(f"s3://{job_args['bucket']}/{job_args['input_key']}")

# order columns for export
ordered_data = data \
  .select(data.ticker, data.market)

now = datetime.now()
date_time = now.strftime("%Y-%m-%d_%H:%M:%S")
destination = f"{job_args['output_key']}{date_time}"

# create destination folder
client.put_object(Bucket=f"{job_args['bucket']}", Key=f"{destination}/")

destination_file = f"{destination}/{job_args['output_filename']}"

# write to destination file using pandas
pandas_to_s3(ordered_data.toPandas(), client, job_args['bucket'], destination_file, ';')