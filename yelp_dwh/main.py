import sys
import argparse
from pathlib import Path

sys.path.append(str(Path(__file__).parent / "src"))

from src.converter.json_to_csv import process_conversions
from src.converter.validator import validate_from_config
from src.database.loader import load_all_staging_data, init_schemas, transform_to_ods, transform_to_dwh
from src.utils.helpers import setup_logging


def main():
    parser = argparse.ArgumentParser(description="Yelp DWH")
    parser.add_argument(
        "command",
        choices=["convert", "validate", "init", "load", "ods", "dwh"],
        help="Command to execute",
    )
    parser.add_argument(
        "--config",
        default="config/config.yaml",
        help="Configuration file path (default: config/config.yaml)",
    )
    parser.add_argument("--db-file", help="Database file path (overrides config)")

    args = parser.parse_args()

    setup_logging()

    try:
        if args.command == "convert":
            print("Converting JSON files to CSV...")
            process_conversions(args.config)

        elif args.command == "validate":
            print("Validating conversion results...")
            validate_from_config(args.config)

        elif args.command == "init":
            print("Initializing database schemas...")
            init_schemas(args.config)

        elif args.command == "load":
            print("Loading CSV data into staging database...")
            load_all_staging_data(args.config, args.db_file)

        elif args.command == "ods":
            print("Transforming staging data to ODS...")
            transform_to_ods(args.config, args.db_file)

        elif args.command == "dwh":
            print("Transforming ODS data to DWH...")
            transform_to_dwh(args.config, args.db_file)

    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
