#!/bin/bash

# Help function
show_help() {
    echo -e "Usage: $0 [-h] [-r]\n"
    echo "Options:"
    echo "  -h, --help       Show this help message"
    echo "  -r, --reinstall  Reinstall, overwriting necessary files"
    exit 0
}

# Check for options
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) show_help ;;
        -r|--reinstall) reinstall=true ;;
        *) echo "Unknown parameter: $1" >&2; exit 1 ;;
    esac
    shift
done

# Banner
echo -e '🚀 Vercelize Laravel 🚀\n'

# Start
echo -e '📦 Starting setup...\n'

# Check if Laravel project is present in the current directory
laravel_project_path="./"

if [ ! -f "${laravel_project_path}/artisan" ]; then
    echo -e "⚠️ It seems that a Laravel project is not present in this directory.\n"
    read -p "Continue anyway? (y/n): " continue_choice
    if [ "$continue_choice" != "y" ] && [ "$continue_choice" != "Y" ]; then
        echo -e "❌ Setup aborted. Please make sure a Laravel project is present in this directory."
        exit 1
    fi
fi

# Check if the "reinstall" option is provided
if [ "$reinstall" = true ]; then
    echo -e "🚨 Reinstall option selected. Overwriting necessary files...\n"
    rm -rf .env.vercel vercel.json api .vercelignore
fi

# Check if .env.vercel file exists
if [ -f ".env.vercel" ]; then
    # Load .env.vercel file
    export $(cat .env.vercel | grep -v ^# | xargs)
    echo -e "🔧 Loaded values from .env.vercel file\n"
elif [ -f ".env" ]; then
    # Load .env file
    export $(cat .env | grep -v ^# | xargs)
    echo -e "🔧 Loaded values from .env file\n"
else
    echo -e "❌ Neither .env.vercel nor .env file found. Please create one of them.\n"
    exit 1
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
echo -e "🔧 APP_URL set to: $APP_URL\n"

# Prompt or display APP_ENV
read -p "⚙️ Enter the value for APP_ENV (default: ${APP_ENV:-'production'}): " user_app_env
APP_ENV=${user_app_env:-${APP_ENV:-'production'}}
echo -e "🔧 APP_ENV set to: $APP_ENV\n"

# Prompt or display APP_DEBUG
read -p "🚨 Enter the value for APP_DEBUG (default: ${APP_DEBUG:-'true'}): " user_app_debug
APP_DEBUG=${user_app_debug:-${APP_DEBUG:-'true'}}
echo -e "🔧 APP_DEBUG set to: $APP_DEBUG\n"

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
