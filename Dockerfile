# Use an official lightweight Python image
FROM python:3.10-slim

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies (LibreOffice CLI)
RUN apt-get update && apt-get install -y libreoffice && apt-get clean

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all application files into the container
COPY . .

# Ensure start.sh is executable
RUN chmod +x start.sh

# Expose the port Flask will run on
EXPOSE 5000

# Run the app using the start.sh script
CMD ["./start.sh"]
