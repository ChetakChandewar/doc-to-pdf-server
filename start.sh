#!/bin/bash

# Update package list and install LibreOffice
apt update && apt install -y libreoffice

# Start the Flask server
gunicorn -w 4 -b 0.0.0.0:5000 app:app
