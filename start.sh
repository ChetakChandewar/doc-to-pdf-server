#!/bin/sh

# Start LibreOffice in headless mode (necessary for unoconv)
soffice --headless --invisible --accept="socket,host=127.0.0.1,port=2002;urp;" &

# Wait for LibreOffice to initialize
sleep 5

# Start the Python application
python3 app.py
