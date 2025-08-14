import polars as pl
import sys
import logging
from ..utils.helpers import (
    load_config,
    get_conversions,
    validate_conversion_entry,
    file_exists,
)


def validate_file_pair(source: str, target: str, dataset: str) -> bool:
    if not file_exists(source):
        logging.error(f"[{dataset}] Source file not found: {source}")
        return False

    if not file_exists(target):
        logging.error(f"[{dataset}] Target file not found: {target}")
        return False

    try:
        with open(source) as f:
            source_count = sum(1 for _ in f)

        target_df = pl.read_csv(target)
        target_count = len(target_df)

        if source_count == target_count:
            logging.info(f"[{dataset}] Records match: {source_count:,}")
            return True
        else:
            logging.error(
                f"[{dataset}] Mismatch - Source: {source_count:,}, Target: {target_count:,}"
            )
            return False

    except Exception as e:
        logging.error(f"[{dataset}] Validation failed: {e}")
        return False


def validate_from_config(config_file: str = "config/config.yaml") -> None:
    try:
        config = load_config(config_file)
        conversions = get_conversions(config)

        if not conversions:
            logging.warning("No conversions found in config file")
            return

        logging.info(f"Validating {len(conversions)} conversions from {config_file}")
        print()

        success_count = 0
        total_count = len(conversions)

        for conversion in conversions:
            if not validate_conversion_entry(conversion):
                dataset = conversion.get("dataset", "unknown")
                logging.error(f"[{dataset}] Missing required fields in config")
                continue

            source = conversion["source"]
            target = conversion["target"]
            dataset = conversion["dataset"]

            is_valid = validate_file_pair(source, target, dataset)
            if is_valid:
                success_count += 1

        print()
        logging.info(
            f"Validation complete: {success_count}/{total_count} conversions valid"
        )

        if success_count == total_count:
            logging.info("Record count checks passed")
        else:
            logging.error(f"{total_count - success_count} record count checks failed")
            sys.exit(1)

    except FileNotFoundError:
        logging.error(f"Configuration file not found: {config_file}")
        sys.exit(1)
    except Exception as e:
        logging.error(f"Error processing config: {e}")
        sys.exit(1)
