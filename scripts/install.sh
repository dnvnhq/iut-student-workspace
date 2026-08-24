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

# Update Vite config for Docker environment
vite_config=""
if [ -f vite.config.ts ]; then
    vite_config=vite.config.ts
elif [ -f vite.config.js ]; then
    vite_config=vite.config.js
fi

if [ -n "$vite_config" ] && ! grep -q "host: '0.0.0.0'" "$vite_config"; then
    vite_config_tmp="$(mktemp)"

    if grep -q "server:[[:space:]]*{" "$vite_config"; then
        awk '
            !inserted && /^[[:space:]]*server:[[:space:]]*{/ {
                print
                print "        host: '\''0.0.0.0'\'',"
                print "        hmr: {"
                print "            host: '\''127.0.0.1'\''"
                print "        },"
                print "        cors: true,"
                inserted = 1
                next
            }
            { print }
        ' "$vite_config" > "$vite_config_tmp"
    else
        awk '
            { print }
            !inserted && /export default defineConfig\(\{/ {
                print "    server: {"
                print "        host: '\''0.0.0.0'\'',"
                print "        hmr: {"
                print "            host: '\''127.0.0.1'\''"
                print "        },"
                print "        cors: true,"
                print "    },"
                inserted = 1
            }
        ' "$vite_config" > "$vite_config_tmp"
    fi

    mv "$vite_config_tmp" "$vite_config"
fi
