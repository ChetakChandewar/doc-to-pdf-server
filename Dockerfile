# Use a minimal Python image
FROM debian:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LIBREOFFICE_HOME=/usr/lib/libreoffice

# Install dependencies
RUN apt-get update && apt-get install -y \
    libreoffice \
    libreoffice-common \
    libreoffice-writer \
    libreoffice-calc \
    libreoffice-impress \
    unoconv \
    python3 \
    python3-pip

# Ensure `unoconv` can find LibreOffice
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN mkdir -p /var/lib/libreoffice && chmod -R 777 /var/lib/libreoffice

# Add Flask app
WORKDIR /app
COPY . /app
RUN pip3 install -r requirements.txt

# Expose port
EXPOSE 8080

# Start the Flask server
CMD ["python3", "app.py"]
