#!/bin/bash

# Fix Permissions Script for Loki Production Setup
# This script fixes all permission issues for Loki and Grafana containers

set -e

echo "🔧 Fixing permissions for Loki Production Setup..."

# Create all necessary directories
echo "📁 Creating directories..."
mkdir -p data/{wal,index,chunks,cache,compactor,distributor,ingester-1,ingester-2,ingester-3,querier,query-frontend,index-gateway,grafana,promtail,loki/index,loki/index-cache,loki/chunks} 2>/dev/null || true
mkdir -p data/compactor/data/{deletion,retention} 2>/dev/null || true
mkdir -p data/grafana/{plugins,csv,pdf} 2>/dev/null || true
mkdir -p data/ingester-1/wal data/ingester-2/wal data/ingester-3/wal 2>/dev/null || true

# Set proper permissions for all data directories
echo "🔐 Setting permissions..."
chmod -R 755 data/ 2>/dev/null || true

# Set specific permissions for critical directories
chmod -R 777 data/compactor/data/ 2>/dev/null || true
chmod -R 777 data/grafana/ 2>/dev/null || true
chmod -R 777 data/ingester-*/wal/ 2>/dev/null || true

# Ensure config files are readable
echo "📄 Setting config file permissions..."
chmod 644 config/*.yaml 2>/dev/null || true

# Create .gitignore if it doesn't exist
if [ ! -f .gitignore ]; then
    echo "📝 Creating .gitignore..."
    cat > .gitignore << 'EOF'
# Loki Data Directory
data/

# Mount Directory
mnt/

# Archive Files
archive.zip
Archive.zip

# macOS
.DS_Store

# Docker
.docker-compose.yaml.swp

# Logs
*.log

# Temporary files
*.tmp
*.temp
EOF
fi

echo "✅ Permission fixes completed!"
echo "🚀 You can now restart your services:"
echo "   docker compose down"
echo "   docker compose up -d" 
