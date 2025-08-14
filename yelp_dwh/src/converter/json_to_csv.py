import polars as pl
import logging
from pathlib import Path
from ..utils.helpers import (
    load_config,
    setup_logging,
    get_conversions,
    ensure_output_dir,
    file_exists,
)


def convert_json(input_file: str, output_file: str, overwrite: bool = True) -> None:
    logging.info(f"Starting conversion: {input_file} -> {output_file}")

    if not file_exists(input_file):
        raise FileNotFoundError(f"Input file not found: {input_file}")

    if file_exists(output_file) and not overwrite:
        logging.warning(f"Output file exists and overwrite=False: {output_file}")
        return

    ensure_output_dir(output_file)

    try:
        # Read with schema inference disabled to handle inconsistent nesting
        df = pl.read_ndjson(input_file, infer_schema_length=None)

        # Convert all object/list columns to JSON strings
        for col in df.columns:
            if df[col].dtype in [pl.Object, pl.List, pl.Struct]:
                df = df.with_columns(
                    pl.col(col)
                    .map_elements(
                        lambda x: str(x) if x is not None else None,
                        return_dtype=pl.Utf8,
                    )
                    .alias(col)
                )

        # Clean newlines in text columns to prevent CSV parsing issues
        for col in df.columns:
            if df[col].dtype == pl.Utf8:
                df = df.with_columns(
                    pl.col(col).str.replace_all("\n", " ").str.replace_all("\r", " ")
                )

        df.write_csv(output_file)
        logging.info("Conversion completed successfully")
    except Exception as e:
        logging.error(f"Conversion failed: {e}")
        raise


def process_conversions(config_file: str = "config/config.yaml") -> None:
    try:
        config = load_config(config_file)

        settings = config.get("settings", {})
        setup_logging(settings.get("log_level", "INFO"))
        overwrite = settings.get("overwrite_existing", True)

        conversions = get_conversions(config)
        logging.info(f"Processing {len(conversions)} conversions")

        for i, conversion in enumerate(conversions, 1):
            source = conversion["source"]
            target = conversion["target"]

            logging.info(f"[{i}/{len(conversions)}] Processing: {source}")
            try:
                source_path = Path(source)
                if source_path.suffix.lower() == '.json':
                    convert_json(source, target, overwrite)
                else:
                    logging.warning(f"Unsupported file type: {source_path.suffix}")
                    continue
            except Exception as e:
                logging.error(f"Failed to process {source}: {e}")
                continue

        logging.info("All conversions completed")

    except FileNotFoundError:
        logging.error(f"Configuration file not found: {config_file}")
        raise
    except Exception as e:
        logging.error(f"Error processing conversions: {e}")
        raise
