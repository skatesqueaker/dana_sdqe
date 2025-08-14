import duckdb
import logging
from pathlib import Path
from ..utils.helpers import load_config


def execute_sql_file(conn: duckdb.DuckDBPyConnection, sql_file: Path) -> None:
    sql_content = sql_file.read_text()
    conn.execute(sql_content)
    logging.debug(f"Executed SQL file: {sql_file}")


def init_schemas(config_file: str = "config/config.yaml", db_file: str = None) -> None:
    config = load_config(config_file)

    if db_file is None:
        db_file = config.get("database", {}).get("yelp", "yelp_dwh.duckdb")

    conn = duckdb.connect(db_file)
    logging.info(f"Connected to DuckDB: {db_file}")

    sql_file = Path("sql/ddl/create_schemas.sql")

    if not sql_file.exists():
        raise FileNotFoundError(f"Schema creation SQL file not found: {sql_file}")

    try:
        execute_sql_file(conn, sql_file)
        logging.info("Initialized database schemas (staging, ods, dwh)")
    except Exception as e:
        # Ignore system.log_table error if it doesn't exist
        if "system.log_table" not in str(e):
            raise
        else:
            # Execute without the logging part
            conn.execute("CREATE SCHEMA IF NOT EXISTS staging")
            conn.execute("CREATE SCHEMA IF NOT EXISTS ods") 
            conn.execute("CREATE SCHEMA IF NOT EXISTS dwh")
            logging.info("Initialized database schemas (staging, ods, dwh) - skipped logging")


def create_tables_from_ddl(conn: duckdb.DuckDBPyConnection, sql_file_path: str) -> None:
    sql_file = Path(sql_file_path)

    if not sql_file.exists():
        raise FileNotFoundError(f"Tables SQL file not found: {sql_file}")

    execute_sql_file(conn, sql_file)
    logging.info(f"Created tables from {sql_file}")


def load_csv_to_table(
    conn: duckdb.DuckDBPyConnection, csv_file: str, table_name: str
) -> int:
    if not Path(csv_file).exists():
        logging.warning(f"CSV file not found: {csv_file}")
        return 0

    conn.execute(f"DELETE FROM {table_name}")

    try:
        conn.execute(f"""
            INSERT INTO {table_name}
            SELECT * FROM read_csv_auto('{csv_file}')
        """)

        row_count = conn.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]
        logging.info(f"Loaded {row_count:,} rows into {table_name}")
        return row_count

    except Exception as e:
        logging.error(f"Failed to load {csv_file} into {table_name}: {e}")
        return 0


def load_all_staging_data(
    config_file: str = "config/config.yaml", db_file: str = None
) -> None:
    config = load_config(config_file)

    if db_file is None:
        db_file = config.get("database", {}).get("yelp", "yelp_dwh.duckdb")

    conn = duckdb.connect(db_file)
    logging.info(f"Connected to DuckDB: {db_file}")

    try:
        create_tables_from_ddl(conn, "sql/ddl/create_staging_tables.sql")
        
        total_rows = 0
        successful_loads = 0
        
        for conversion in config.get("conversions", []):
            dataset = conversion["dataset"]
            csv_file = conversion["target"]
            table_name = f"staging.{dataset}"

            logging.info(f"Loading {dataset}...")
            rows = load_csv_to_table(conn, csv_file, table_name)

            if rows > 0:
                total_rows += rows
                successful_loads += 1
        
        for csv_source in config.get("csv_sources", []):
            dataset = csv_source["dataset"]
            csv_file = csv_source["source"]  # direct source, not target
            table_name = f"staging.{dataset}"

            logging.info(f"Loading {dataset}...")
            rows = load_csv_to_table(conn, csv_file, table_name)

            if rows > 0:
                total_rows += rows
                successful_loads += 1

        logging.info(
            f"Loading complete: {successful_loads} tables, {total_rows:,} total rows"
        )
        print(f"\nDatabase file: {Path(db_file).absolute()}")
        print(f"Database size: {Path(db_file).stat().st_size / 1024 / 1024:.1f} MB")

    finally:
        conn.close()


def transform_to_ods(
    config_file: str = "config/config.yaml", db_file: str = None
) -> None:
    config = load_config(config_file)

    if db_file is None:
        db_file = config.get("database", {}).get("yelp", "yelp_dwh.duckdb")

    conn = duckdb.connect(db_file)
    logging.info(f"Connected to DuckDB for ODS transformation: {db_file}")

    try:
        create_tables_from_ddl(conn, "sql/ddl/create_ods_tables.sql")
        
        ods_transforms = [
            "sql/ods/transform_business.sql",
            "sql/ods/transform_user.sql", 
            "sql/ods/transform_review.sql",
            "sql/ods/transform_tip.sql",
            "sql/ods/transform_checkin.sql",
            "sql/ods/transform_weather_precipitation.sql",
            "sql/ods/transform_weather_temperature.sql"
        ]
        
        successful_transforms = 0
        
        for transform_file in ods_transforms:
            transform_path = Path(transform_file)
            if transform_path.exists():
                logging.info(f"Running ODS transformation: {transform_file}")
                execute_sql_file(conn, transform_path)
                successful_transforms += 1
            else:
                logging.warning(f"Transform file not found: {transform_file}")
        
        logging.info(f"ODS transformation complete: {successful_transforms}/{len(ods_transforms)} transforms executed")
    except Exception as e:
        logging.error(f"ODS transformation failed: {e}")
        raise
    finally:
        conn.close()


def transform_to_dwh(
    config_file: str = "config/config.yaml", db_file: str = None
) -> None:
    config = load_config(config_file)

    if db_file is None:
        db_file = config.get("database", {}).get("yelp", "yelp_dwh.duckdb")

    conn = duckdb.connect(db_file)
    logging.info(f"Connected to DuckDB for DWH transformation: {db_file}")

    try:
        create_tables_from_ddl(conn, "sql/ddl/create_dwh_tables.sql")
        
        dwh_transforms = [
            "sql/dwh/transform_dimensions.sql",
            "sql/dwh/transform_facts.sql"
        ]
        
        successful_transforms = 0
        
        for transform_file in dwh_transforms:
            transform_path = Path(transform_file)
            if transform_path.exists():
                logging.info(f"Running DWH transformation: {transform_file}")
                execute_sql_file(conn, transform_path)
                successful_transforms += 1
            else:
                logging.warning(f"Transform file not found: {transform_file}")
        
        logging.info(f"DWH transformation complete: {successful_transforms}/{len(dwh_transforms)} transforms executed")
    except Exception as e:
        logging.error(f"DWH transformation failed: {e}")
        raise
    finally:
        conn.close()
