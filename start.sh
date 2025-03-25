#!/bin/sh

echo "Starting LibreOffice in headless mode..."
soffice --headless --invisible --accept="socket,host=127.0.0.1,port=2002;urp;" &
sleep 5  # Wait for LibreOffice to start

echo "Starting Flask app..."
python3 app.py
