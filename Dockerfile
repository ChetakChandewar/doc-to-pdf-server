# Use a minimal Debian image
FROM debian:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LIBREOFFICE_HOME=/usr/lib/libreoffice

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libreoffice \
    libreoffice-common \
    libreoffice-writer \
    libreoffice-calc \
    libreoffice-impress \
    unoconv \
    python3 \
    python3-pip \
    python3-venv

# Set up working directory
WORKDIR /app
COPY . /app

# Create a virtual environment and install dependencies
RUN python3 -m venv venv
RUN . venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt

# Expose the application port
EXPOSE 8080

# Start the script
CMD ["/bin/bash", "-c", ". venv/bin/activate && python app.py"]
