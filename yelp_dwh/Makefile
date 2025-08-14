.PHONY: help setup install convert validate init load ods clean lint format benchmark

help:
	@echo "Yelp DWH"
	@echo ""
	@echo "Local Commands:"
	@echo "  setup              - Create necessary directories"
	@echo "  install            - Install Python dependencies"
	@echo "  convert            - Convert JSON files to CSV"
	@echo "  validate           - Validate conversion results"
	@echo "  init               - Initialize database schemas"
	@echo "  load               - Load CSV data into staging database"
	@echo "  ods                - Transform staging data to ODS"
	@echo "  dwh                - Transform ODS data to DWH"
	@echo "  clean              - Clean output files and databases"
	@echo "  lint               - Run code linting"
	@echo "  format             - Run code formatting"
	@echo "  benchmark          - Run performance benchmarks"

setup:
	@echo "Creating directories..."
	mkdir -p data/input data/output logs
	@echo "Setup complete!"

install:
	pip install -r requirements.txt

convert:
	python main.py convert

validate:
	python main.py validate

init:
	python main.py init

load:
	python main.py load

ods:
	python main.py ods

dwh:
	python main.py dwh

clean:
	@echo "Cleaning output files and databases..."
	rm -rf data/output/*.csv
	rm -rf data/*.duckdb
	rm -rf logs/*.log
	@echo "Clean complete!"

lint:
	ruff check src/ main.py

format:
	ruff format src/ main.py

benchmark:
	@echo "Running hyperfine benchmark..."
	hyperfine --warmup 1 --prepare 'rm -f data/output/*.csv' \
		--export-markdown benchmark_results.md \
		--export-json benchmark_results.json \
		'python main.py convert'
