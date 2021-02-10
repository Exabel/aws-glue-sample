
# This script is originally created with AWS Glue Studio
# It has been altered to dynamically add job_args

import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrameCollection
from awsglue.dynamicframe import DynamicFrame

def MyTransform(glueContext, dfc) -> DynamicFrameCollection:
    from pyspark.sql.functions import lit
    df = dfc.select(list(dfc.keys())[0]).toDF()
    df = df.drop_duplicates(subset=['ticker'])
    df = df.withColumn("market", lit('US'))
    aws_df = DynamicFrame.fromDF(df, glueContext, "conversion")
    return(DynamicFrameCollection({"CustomTransform0": aws_df}, glueContext))
def AggregateSignal(glueContext, dfc) -> DynamicFrameCollection:
    from pyspark.sql.functions import lit
    df = dfc.select(list(dfc.keys())[0]).toDF()
    df = df.groupby('ticker', 'date').agg({"signal1": "sum"}).withColumnRenamed('sum(signal1)', 'signal1')
    df = df.withColumn('market', lit('US'))
    aws_df = DynamicFrame.fromDF(df, glueContext, "conversion")
    return(DynamicFrameCollection({"CustomTransform0": aws_df}, glueContext))

## @params: [JOB_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME',
                                     'bucket',
                                     'database-name',
                                     'database-table-prefix'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

DataSource0 = glueContext.create_dynamic_frame.from_catalog(database = args['database_name'], table_name = f"{args['database_table_prefix']}chain_venues", transformation_ctx = "DataSource0")

Transform10 = ApplyMapping.apply(frame = DataSource0, mappings = [("venueid", "string", "venues_venueid", "string"), ("chainid", "string", "chainid", "string")], transformation_ctx = "Transform10")

DataSource2 = glueContext.create_dynamic_frame.from_catalog(database = args['database_name'], table_name = f"{args['database_table_prefix']}chain_tickers", transformation_ctx = "DataSource2")

Transform4 = SelectFields.apply(frame = DataSource2, paths = ["ticker"], transformation_ctx = "Transform4")

Transform7 = MyTransform(glueContext, DynamicFrameCollection({"Transform4": Transform4}, glueContext))

Transform8 = SelectFromCollection.apply(dfc = Transform7, key = list(Transform7.keys())[0], transformation_ctx = "Transform8")

DataSink1 = glueContext.write_dynamic_frame.from_options(frame = Transform8, connection_type = "s3", format = "csv", connection_options = {"path": f"s3://{args['bucket']}/data/etl-output/mapping/identities/", "compression": "gzip", "partitionKeys": []}, transformation_ctx = "DataSink1")

Transform1 = ApplyMapping.apply(frame = DataSource2, mappings = [("chainid", "string", "chain_tickers_chainid", "string"), ("ticker", "string", "ticker", "string")], transformation_ctx = "Transform1")

Transform0 = Join.apply(frame1 = Transform10, frame2 = Transform1, keys2 = ["chain_tickers_chainid"], keys1 = ["chainid"], transformation_ctx = "Transform0")

Transform11 = SelectFields.apply(frame = Transform0, paths = ["venues_venueid", "ticker"], transformation_ctx = "Transform11")

DataSource1 = glueContext.create_dynamic_frame.from_catalog(database = args['database_name'], table_name = f"{args['database_table_prefix']}data_set", transformation_ctx = "DataSource1")

Transform5 = ApplyMapping.apply(frame = DataSource1, mappings = [("venueid", "string", "venueid", "string"), ("utc_date", "string", "date", "string"), ("dwell", "long", "signal1", "long")], transformation_ctx = "Transform5")

Transform9 = Join.apply(frame1 = Transform5, frame2 = Transform11, keys2 = ["venues_venueid"], keys1 = ["venueid"], transformation_ctx = "Transform9")

Transform3 = DropFields.apply(frame = Transform9, paths = ["venueid", "venues_venueid"], transformation_ctx = "Transform3")

Transform2 = AggregateSignal(glueContext, DynamicFrameCollection({"Transform3": Transform3}, glueContext))

Transform6 = SelectFromCollection.apply(dfc = Transform2, key = list(Transform2.keys())[0], transformation_ctx = "Transform6")

DataSink0 = glueContext.write_dynamic_frame.from_options(frame = Transform6, connection_type = "s3", format = "csv", connection_options = {"path": f"s3://{args['bucket']}/data/etl-output/time-series/extracted/", "compression": "gzip", "partitionKeys": ["ticker"]}, transformation_ctx = "DataSink0")
job.commit()