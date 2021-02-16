#!/usr/bin/env sh

set -e

export DATABASE_URL=${DATABASE_URL}

echo "Running migrations..."
bin/xq_archive eval "XQ.Archive.Release.migrate"
echo "Starting xq_archive..."
bin/xq_archive start
