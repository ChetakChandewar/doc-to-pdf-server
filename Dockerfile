# Use a lightweight Python image
FROM python:3.11

# Install dependencies
RUN apt-get update && apt-get install -y \
    libreoffice libreoffice-common unoconv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Start LibreOffice in headless mode before running the app
CMD ["sh", "start.sh"]
