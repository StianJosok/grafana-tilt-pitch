# Use the official Python image as the base
FROM python:3.9-slim

# Set environment variables to prevent Python from writing .pyc files and to buffer stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies required by pybluez and Bluetooth support
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libbluetooth-dev \
        bluez \
        git \
        python3-dev \
        libffi-dev \
        && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Pin setuptools to a compatible version
RUN pip install setuptools==57.5.0

# Copy requirements.txt to the working directory
COPY requirements.txt .

# Install Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install pybluez directly from GitHub
RUN pip install git+https://github.com/pybluez/pybluez.git#egg=pybluez

# Copy the application code into the container
COPY . .

# Expose port 8000 for Prometheus metrics, as per project defaults
EXPOSE 8000

# Set the default command to run the application
CMD ["python", "-m", "pitch"]
