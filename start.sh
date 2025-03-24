#!/bin/bash
# Start LibreOffice as a service
soffice --headless --accept="socket,host=127.0.0.1,port=2002;urp;" --nofirststartwizard &

# Start Flask server
python3 app.py
