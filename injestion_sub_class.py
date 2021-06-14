from typing import Dict
import injestion_base_class


class Data_Ingestion_Subclass(injestion_base_class.Data_Ingestion):
    """There is basic data transformation.."""

    def __init__(self, schema_file_name: str, csv_file_name: str, resources_dir: str = "resources"):
        super().__init__(schema_file_name, csv_file_name, resources_dir)

    def get_single_row_transformed(self, csv_line: str) -> Dict[str, str]:
        """This method translates a single line of comma separated values to a
    dictionary which can be loaded into BigQuery

        Args:
            csv_line (str): A comma separated single csv line
                example: KS1,F1,1923,Dorothy1,654,11/28/2016

        Returns:
            Dict[str,str]: A dict mapping schema column names with the values from Arg csv_line 
            with year column transformed into YYYY-MM-DD format which BigQuery accepts
                example: {'state': 'KS1', 'gender': 'F1', 'year': '1923-01-01', 'name': 'Dorothy1', 'number': '654', 'created_date': '11/28/2016'}
        """
        list1 = self.get_schema_column_names()
        list2 = csv_line.split(",")
        year = "-".join((list2[2], "01", "01"))
        list2[2] = year
        combined_list = zip(list1, list2)
        single_row = dict(combined_list)
        return single_row


def main():
    args = injestion_base_class.parse_args()
    transformed_data_injestion = Data_Ingestion_Subclass(
        args.schema_filename, args.csv_filename, args.files_dir)
    with open(transformed_data_injestion.csv_file_path) as f:
        lines = f.readlines()
        for line in lines:
            print(transformed_data_injestion.get_single_row_transformed(line.strip()))


if __name__ == "__main__":
    main()
