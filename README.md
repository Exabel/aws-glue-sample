# AWS Glue sample project

Example data pipeline that uses the Exable Python SDK for timeseries data loading.

Pre-requisites:

- Amazon AWS account set up with a user with a role suitable for using AWS Glue. See: https://docs.aws.amazon.com/glue/latest/dg/getting-started-access.html
- AWS CLI version 2 installed and configured. See: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html <br>Remember to set up configuration for your preferred region.
- API key and hostname for the Exabel API provided by Exabel.

# Install

To setup the project in AWS first edit the aws/congiguration.sh file. The variables that needs to be configured are:

- aws_role: ARN for your AWS Glue role provided by you.
- exabel_api_key: Exabel API key provided by Exabel.
- exabel_api_host: Exabel API hostname provided by Exabel.
- signals: a list of one of more signal qualifiers provided by Exabel.

Other settings in configutation.sh may also be changed.

To install the project to AWS Glue run 'project-setup.sh' in the aws directory. After the script 
finishes a fully functional pipeline has been installed in your AWS account. This includes a 
Crawler and Database, Jobs, Triggers, Worksflow and a S3 Bucket for storage.

Running the Workflow starts the full data pipeline.

# Uninstall

To uninstall the project from the AWS account run 'project-teardown.sh' in the aws directory.

# Jobs in pipeline 

- extract-job: Input is data in 3 tables that was populated with a Crawler. Output is 2 sets of csv 
  files. The first is extracted and aggregated timeseries data with client id's. The second is a client id
  mapping.
  
- mapping-prepare-job: Input is a set of csv files with rows containing client id's. 
  Output is a single CSV file with rows containing the client id's.

- entity-mapping-job: Input is a csv file with rows consisting of client provided id's. 
  Output is a mapping file consisting of rows with Exabel entity names corresponding to 
  the client provided id's. This uses the Exabel Python SDK.
  
- timeseries-prepare-job: Input is a set of csv files containing rows of timeseries data *and* a single
  csv file with rows containing a mapping from client id's to Exabel entities. The rows from the inputs 
  are joined to create a single output csv file with rows containing Exabel entity id's and timeseries data.

- load-timeseries-job: Input is a csv file with rows consisting of Exabel entity id's and timeseries data.
  This data is loaded into the Exabel database. This uses the Exabel Python SDK.