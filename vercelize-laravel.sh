#!/bin/bash

# Banner
echo -e '🚀 Vercelize Laravel 🚀\n'

# Start
echo -e '📦 Starting setup...\n'

# Check if .env file exists
if [ -f ".env" ]; then
    # Load .env file
    export $(cat .env | grep -v ^# | xargs)
    echo -e "🔧 Loaded values from .env file\n"
fi

# Function to create file if it does not exist
create_file() {
    if [ ! -e "$1" ]; then
        touch "$1"
        echo -e "📄 Created $1\n"
    else
        echo -e "📄 $1 already exists\n"
    fi
}

# Function to create folder if it does not exist
create_folder() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        echo -e "📁 Created $1\n"
    else
        echo -e "📁 $1 already exists\n"
    fi
}

# Prompt or display APP_URL
read -p "🌐 Enter the value for APP_URL (default: ${APP_URL:-'https://yourproductionurl.com'}): " user_app_url
APP_URL=${user_app_url:-${APP_URL:-'https://yourproductionurl.com'}}
echo "🔧 APP_URL set to: $APP_URL\n"

# Prompt or display APP_ENV
read -p "⚙️ Enter the value for APP_ENV (default: ${APP_ENV:-'production'}): " user_app_env
APP_ENV=${user_app_env:-${APP_ENV:-'production'}}
echo "🔧 APP_ENV set to: $APP_ENV\n"

# Prompt or display APP_DEBUG
read -p "🚨 Enter the value for APP_DEBUG (default: ${APP_DEBUG:-'true'}): " user_app_debug
APP_DEBUG=${user_app_debug:-${APP_DEBUG:-'true'}}
echo "🔧 APP_DEBUG set to: $APP_DEBUG\n"

# Create api folder and index.php file
echo -e '📁 Creating api folder and index.php file...\n'
create_folder "api"
create_file "api/index.php"
cat <<'EOF' > api/index.php
<?php

// Forward Vercel requests to normal index.php
require __DIR__ . '/../public/index.php';
EOF

# Create .vercelignore file
echo -e '📄 Creating .vercelignore file...\n'
create_file ".vercelignore"
echo '/vendor' > .vercelignore

# Create vercel.json file
echo -e '📄 Creating vercel.json file...\n'
create_file "vercel.json"
cat <<EOF > vercel.json
{
    "version": 2,
    "functions": {
        "api/index.php": { "runtime": "vercel-php@0.6.0" }
    },
    "routes": [{
        "src": "/(.*)",
        "dest": "/api/index.php"
    }],
    "outputDirectory": "public",
    "env": {
        "APP_ENV": "$APP_ENV",
        "APP_DEBUG": "$APP_DEBUG",
        "APP_URL": "$APP_URL",
        "APP_CONFIG_CACHE": "/tmp/config.php",
        "APP_EVENTS_CACHE": "/tmp/events.php",
        "APP_PACKAGES_CACHE": "/tmp/packages.php",
        "APP_ROUTES_CACHE": "/tmp/routes.php",
        "APP_SERVICES_CACHE": "/tmp/services.php",
        "VIEW_COMPILED_PATH": "/tmp",
        "CACHE_DRIVER": "array",
        "LOG_CHANNEL": "stderr",
        "SESSION_DRIVER": "cookie"
    }
}
EOF

# Ask if the user wants to run "vercel" command
read -p '🚀 Do you want to run the "vercel" command now? (y/n): ' choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    vercel
fi

echo -e '✅ Setup completed. Your project is now Vercel-ready.\n'
