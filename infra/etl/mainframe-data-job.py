import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark import SparkFiles
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import col, lit
from awsglue.dynamicframe import DynamicFrame

## @params: [JOB_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME', 'BUCKET_OBJECT_PATH'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)
bucket_object_path = args['BUCKET_OBJECT_PATH']
## @type: DataSource
## @args: [database = "produtos", table_name = "raw", transformation_ctx = "datasource0"]
## @return: datasource0
## @inputs: []
datasource0 = glueContext.create_dynamic_frame.from_catalog(
    database = "produtos",
    table_name = "raw",
    transformation_ctx = "datasource0")

data_raw = datasource0.toDF()

print("data raw count {}".format(data_raw.count()))

schema = spark.read.format('csv').options(header='true', inferSchema='true').load(bucket_object_path)

print("loaded schema")

schema.show()

# transformacao do posicional para parqueta partir do arquivo de configuracao

parsed_rows = []
for row in data_raw.collect():
    columns = []
    for metadata in schema.collect():
        word_length = metadata.pos_ini+metadata.length
        column_value = row.fields[metadata.pos_ini:word_length]
        columns.append(column_value.strip())
    parsed_rows.append(tuple(columns))

dd = spark.createDataFrame(parsed_rows, schema.select('field').rdd.flatMap(lambda x: x).collect())

for metadata in schema.collect():
    dd = dd.withColumn(metadata.field, col(metadata.field).cast(metadata.data_type))

print('transformed data')

dd.show()

dd.printSchema()

applymapping1 = DynamicFrame.fromDF(dd, glueContext, "applymapping1")

resolvechoice2 = ResolveChoice.apply(
    frame = applymapping1,
    choice = "make_struct",
    transformation_ctx = "resolvechoice2"
)

dropnullfields3 = DropNullFields.apply(frame = resolvechoice2, transformation_ctx = "dropnullfields3")

datasink4 = glueContext.write_dynamic_frame.from_options(
    frame = dropnullfields3,
    connection_type = "s3",
    connection_options = {"path": "s3://projeto-aplicado-produtos-glue/processed"},
    format = "parquet",
    transformation_ctx = "datasink4"
)

job.commit()