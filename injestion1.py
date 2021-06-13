import os
import csv


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

    def get_schema_fieldnames(self) -> list:
        """[reads schema file]

        Returns:
            list: [list of fieldnames]
        """
        with open(self.schema_file_path) as f:
            schema_str = f.read()
            schema_list = eval(schema_str)
            return [i["name"] for i in schema_list]

    def get_single_row(self, csv_record: list) -> dict:
        """

        Args:
            csv_record (list): [list of values of a single csv record]

        Returns:
            dict: [dict with keys as schema fieldnames and values of a single csv record ]
        """
        list1 = self.get_schema_fieldnames()
        list2 = csv_record
        combined_list = zip(list1, list2)
        single_row_dict = dict(combined_list)
        return single_row_dict

    def print_row(self, csv_record) -> None:
        row = self.get_single_row(csv_record)
        print(row)


data_injection = Data_Ingestion("usa_names.json", "usa_names.csv")

with open(data_injection.csv_file_path) as f:
    reader = csv.reader(f)
    for i in reader:
        data_injection.print_row(i)
