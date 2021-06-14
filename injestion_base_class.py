import os
from typing import Dict
import argparse


class Data_Ingestion():
    """There is no data transformation."""

    def __init__(self, schema_file_name: str, csv_file_name: str, resources_dir: str = "resources"):
        self.schema_file_name = schema_file_name
        self.csv_file_name = csv_file_name
        self.resources_dir = resources_dir

        current_dir = os.path.dirname(os.path.realpath(__file__))
        schema_file_path = os.path.join(
            current_dir, resources_dir, schema_file_name)
        csv_file_path = os.path.join(current_dir, resources_dir, csv_file_name)
        self.schema_file_path = schema_file_path
        self.csv_file_path = csv_file_path

    def get_schema_column_names(self) -> list:
        """
        Returns:
            list: list of column names in the provided schema file
                example: ["state","gender","year","name","number","created_date"]
        """
        with open(self.schema_file_path) as f:
            schema_str = f.read()
            schema_list = eval(schema_str)
            return [i["name"] for i in schema_list]

    def get_single_row(self, csv_line: str) -> Dict[str, str]:
        """This method translates a single line of comma separated values to a
    dictionary which can be loaded into BigQuery

        Args:
            csv_line (str): A comma separated single csv line
                example: KS1,F1,1923,Dorothy1,654,11/28/2016

        Returns:
            Dict[str,str]: A dict mapping schema column names with the values from Arg csv_line
                example: {'state': 'KS1', 'gender': 'F1', 'year': '1923', 'name': 'Dorothy1', 'number': '654', 'created_date': '11/28/2016'}
        """
        list1 = self.get_schema_column_names()
        list2 = csv_line.split(",")
        combined_list = zip(list1, list2)
        single_row = dict(combined_list)
        return single_row


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument('--schema_filename',
                        required=True,
                        help='Name of the schema file')

    parser.add_argument('--csv_filename',
                        required=True,
                        help='Name of the csv file')

    parser.add_argument('--files_dir',
                        required=False,
                        default="resources",
                        help='Name of dir which contains the schema,csv files')

    args = parser.parse_args()

    return args


def main():
    args = parse_args()
    data_injection = Data_Ingestion(
        args.schema_filename, args.csv_filename, args.files_dir)

    with open(data_injection.csv_file_path) as f:
        lines = f.readlines()
        for line in lines:
            print(data_injection.get_single_row(line.strip()))


if __name__ == "__main__":
    main()
