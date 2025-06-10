import luigi
import sentry_sdk
import pandas as pd
import os

from pipeline.extract import Extract
from pipeline.load import Load
from pipeline.transform import Transform

from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Read env variables
DIR_ROOT_PROJECT = os.getenv("DIR_ROOT_PROJECT")
DIR_TEMP_LOG = os.getenv("DIR_TEMP_LOG")
DIR_TEMP_DATA = os.getenv("DIR_TEMP_DATA")
DIR_LOG = os.getenv("DIR_LOG")

# Execute the functions when the script is run
if __name__ == "__main__":
    # Build the task
    luigi.build([Extract(),
                 Load(),
                 Transform()])