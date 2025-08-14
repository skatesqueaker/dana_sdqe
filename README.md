# DANA SDQE Project

### Yelp Data Warehouse

A data pipeline that transforms Yelp business data and weather information into a star schema data warehouse for analysis.

#### Project Structure

```
yelp_dwh/
├── config/                     # Configuration files
├── data/
│   ├── input/                  # Raw Yelp JSON and weather CSV files
│   ├── output/                 # Converted CSV files
│   └── yelp_dwh.duckdb         # DuckDB database file
├── sql/
│   ├── ddl/                    # Table creation scripts
│   ├── ods/                    # ODS transformation queries
│   ├── dwh/                    # DWH transformation queries
│   └── rollback/               # Rollback/cleanup scripts
└── src/
    ├── converter/              # JSON to CSV conversion
    ├── database/               # Database operations
    └── utils/                  # Helper functions
```

#### Quick Start

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

#### Data Flow

1. **Staging**: Raw data loaded as-is from CSV files
2. **ODS**: Cleaned operational data
3. **DWH**: Star schema with dimensions and facts for analytics

#### Requirements

- Python 3.8+
- DuckDB
- See `requirements.txt` for Python dependencies
