#!/bin/bash

# Start
echo '🚀 Starting setup...'

# Create api folder and index.php file
echo '📁 Creating api folder and index.php file...'
mkdir api
cat <<'EOF' > api/index.php
<?php

// Forward Vercel requests to normal index.php
require __DIR__ . '/../public/index.php';
EOF

# Create .vercelignore file
echo '📁 Creating .vercelignore file...'
echo '/vendor' > .vercelignore

# Create vercel.json file
echo '📁 Creating vercel.json file...'
cat <<'EOF' > vercel.json
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
        "APP_ENV": "production",
        "APP_DEBUG": "true",
        "APP_URL": "https://yourproductionurl.com",
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

echo '✅ Setup completed. Your project is now Vercel-ready.'
