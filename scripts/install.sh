#!/bin/sh
set -eu

bootstrap_dir="$(mktemp -d /tmp/laravel.XXXXXX)"

trap 'rm -rf "$bootstrap_dir"' EXIT INT TERM

# Remove FrankenPHP generate file
rm -rf /app/public

# Install Laravel installer
composer global require laravel/installer

# Create the project in /tmp
cd "$bootstrap_dir"
laravel new application --bun --no-boost

# Copy fresh app into /app
cp -a "$bootstrap_dir/application"/. /app/
cd /app
