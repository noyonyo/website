#!/usr/bin/env bash

# Remove specific host if provided as argument
if [ -n "$1" ]; then
    echo "Removing specific host: $1"
    sudo hostile remove "$1" 2>/dev/null || true
fi

# Remove common development hosts
echo "Removing common development hosts..."
sudo hostile remove dev.nyo.solutions 2>/dev/null || true
sudo hostile remove www.nyo.solutions 2>/dev/null || true
sudo hostile remove mock.nyo.solutions 2>/dev/null || true
sudo hostile remove prod.nyo.solutions 2>/dev/null || true
sudo hostile remove localhost 2>/dev/null || true

echo "Host cleanup completed."
