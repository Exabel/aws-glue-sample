import boto3
import sys

from awsglue.utils import getResolvedOptions
from exabel_data_sdk import ExabelClient
from exabel_data_sdk.scripts.load_time_series_from_csv import LoadTimeSeriesFromCsv


job_args = getResolvedOptions(sys.argv, ['exabel-api-host',
                                         'exabel-api-key',
                                         'bucket',
                                         'input-key',
                                         'input-filename',
                                         'signals'])

# Find a file of time-series data to load with the API
# In this example we load the newest file in argument 'input-key'
# matching argument 'input-filename'

s3_client = boto3.client('s3')

# find latest updated csv in input-key
response = s3_client.list_objects_v2(Bucket=job_args['bucket'],
                                     Prefix=job_args['input_key'])

# Get the key of the object with the highest LastModified date
latest_object = max(response['Contents'], key=lambda obj: obj['LastModified'])['Key']

if job_args['input_filename'] in latest_object:
  input_file = latest_object
else:
  print("Could not find any input files to process")
  exit(1)

# Setup to load input file with signals data to Exabel API
exabel_client = ExabelClient(
    host=job_args['exabel_api_host'], api_key=job_args['exabel_api_key'])
script_args = ["load-timeseries-job",
               "--filename",
               f"s3://{job_args['bucket']}/{input_file}",
               "--signals",
               job_args['signals']]
loader = LoadTimeSeriesFromCsv(script_args, "Load")
loader.run_script(exabel_client, loader.parse_arguments())

