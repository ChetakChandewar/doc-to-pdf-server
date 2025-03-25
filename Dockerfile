# Use a lightweight Debian-based Python image
FROM python:3.11

# Install LibreOffice and unoconv with necessary dependencies
RUN apt-get update && apt-get install -y \
    libreoffice libreoffice-common libreoffice-writer libreoffice-calc libreoffice-impress \
    unoconv python3-uno \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for LibreOffice
ENV UNO_PATH=/usr/lib/libreoffice/program
ENV PYTHONPATH=/usr/lib/libreoffice/program

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the start script and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Start the script when the container runs
CMD ["/start.sh"]
