import os


class Properties:
    """
    Provides a single interface for accessing environment variables, and makes it easy to identify which environment
    variables are being used.
    """
    storage_type = os.environ.get('STORAGE_TYPE')

    ## csv
    # accepted values are 'postgres' or 's3'
    s3_bucket = os.environ.get('S3_BUCKET')
    # 'False' will evaluate to bool(True) otherwise
    write_to_aws = os.environ.get('WRITE_TO_AWS') == 'True'

    ## postgres
    rds_host = os.environ.get('RDS_HOST')
    # https://www.terraform.io/docs/configuration/environment-variables.html#tf_var_name
    prod_db_password = os.environ.get('PROD_DB_PASSWORD')
    local_db_password = os.environ.get('LOCAL_DB_PASSWORD')