# DANA SDQE Project

## Yelp DWH Project Structure

```
yelp_dwh/
├── config/                     # Configuration files
├── data/
│   ├── input/                  # Raw Yelp JSON and weather CSV files
│   ├── output/                 # Converted CSV files
│   └── yelp_dwh.duckdb        # DuckDB database file
├── sql/
│   ├── ddl/                   # Table creation scripts
│   ├── ods/                   # ODS transformation queries
│   ├── dwh/                   # DWH transformation queries
│   └── rollback/              # Rollback/cleanup scripts
└── src/
    ├── converter/             # JSON to CSV conversion
    ├── database/              # Database operations
    └── utils/                 # Helper functions
```

## Quick Start

1. **Setup**
   ```bash
   make setup install
   ```

2. **Process Data Pipeline**
   ```bash
   make convert    # Convert JSON to CSV
   make validate   # Validate conversions
   make init       # Create database schemas
   make load       # Load staging data
   make ods        # Transform to ODS
   make dwh        # Transform to DWH
   ```

## Docker Support

**Build and run:**
```bash
docker build -t yelp-dwh .
docker run -v ./data:/app/data yelp-dwh convert
```

**Full pipeline with Docker Compose:**
```bash
docker-compose up dwh  # Runs entire pipeline (need to adjust service dependencies): convert → validate → init → load → ods → dwh
```

## Data Flow

1. **Staging**: Raw data loaded as-is from CSV files
2. **ODS**: Cleaned and normalized operational data
3. **DWH**: Star schema with dimensions and facts for analytics


## Requirements

- Python 3.10+
- DuckDB
- See `requirements.txt` for Python dependencies

## PDF Documentation

See `docs/` for detailed documentation of the project:
- **DANA - SDQE Submission - Yelp DWH.pdf** - Complete Yelp DWH project overview and architecture
- **DANA - SDQE Submission - TMT DQ Framework.pdf** - Data quality framework implementation
