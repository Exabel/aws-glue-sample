import boto3
import sys

from datetime import datetime

from awsglue.utils import getResolvedOptions
from exabel_data_sdk import ExabelClient
from exabel_data_sdk.scripts.create_entity_mapping_from_csv import CreateEntityMappingFromCsv


# Find an input mapping file and pass it to the Exabel API to create
# a mapping file from client id's to Exabel entities
# In this example we
#   * load the newest file in 'input-key' matching 'input-filename'
#   * create a timestamped directory key under 'output-key'
#     and upload the file with name 'output-filename' there

job_args = getResolvedOptions(sys.argv, ['exabel-api-host', 'exabel-api-key',
                                         'bucket',
                                         'input-key', 'input-filename',
                                         'output-key', 'output-filename'])

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

now = datetime.now()
date_time = now.strftime("%Y-%m-%d_%H:%M:%S")
destination_key = f"{job_args['output_key']}{date_time}"

# create destination folder
s3_client.put_object(Bucket=f"{job_args['bucket']}", Key=f"{destination_key}/")

# Setup to create mapping file using Exabel API
exabel_client = ExabelClient(host=job_args['exabel_api_host'],
                             api_key=job_args['exabel_api_key'])
script_args = [
  "entity-mapping-job",
  "--filename-input",
  f"s3://{job_args['bucket']}/{input_file}",
  "--filename-output",
  f"s3://{job_args['bucket']}/{destination_key}/{job_args['output_filename']}"
]
script = CreateEntityMappingFromCsv(script_args, "EntityMapping")
script.run_script(exabel_client, script.parse_arguments())
