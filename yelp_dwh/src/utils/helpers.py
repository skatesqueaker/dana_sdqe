import yaml
import logging
from pathlib import Path
from typing import Dict, Any, List


def load_config(config_file: str) -> Dict[str, Any]:
    with open(config_file, "r") as f:
        return yaml.safe_load(f)


def setup_logging(log_level: str = "INFO") -> None:
    level = getattr(logging, log_level.upper(), logging.INFO)
    logging.basicConfig(
        level=level, format="%(asctime)s - %(levelname)s - %(message)s", force=True
    )


def get_conversions(config: Dict[str, Any]) -> List[Dict[str, str]]:
    return config.get("conversions", [])


def validate_conversion_entry(conversion: Dict[str, str]) -> bool:
    required_fields = ["source", "target", "dataset"]
    return all(field in conversion and conversion[field] for field in required_fields)


def ensure_output_dir(output_file: str) -> None:
    Path(output_file).parent.mkdir(parents=True, exist_ok=True)


def file_exists(file_path: str) -> bool:
    return Path(file_path).exists()
