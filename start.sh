#!/usr/bin/env sh

set -e

echo "Running migrations..."
bin/xq_archive eval "XQ.Archive.Release.migrate"
echo "Starting xq_archive..."
bin/xq_archive start
