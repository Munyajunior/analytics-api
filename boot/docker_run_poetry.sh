#!/bin/bash

# Set default values for HOST and PORT if not provided
RUN_PORT="${PORT:-8000}"
RUN_HOST="${HOST:-0.0.0.0}"

# Move into project directory
cd /code

# Run the app using Poetry + Gunicorn with Uvicorn worker
exec poetry run gunicorn -k uvicorn.workers.UvicornWorker -b "$RUN_HOST:$RUN_PORT" main:app
