# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /app

# Install git and nginx
RUN apt-get update && apt-get install -y git nginx

# Clone the repository
RUN git clone https://github.com/tuller01/resume.git .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy nginx config
RUN cp nginx.conf /etc/nginx/sites-available/default

# Make port 80 available to the world outside this container
EXPOSE 80

# Start Gunicorn and Nginx
CMD service nginx start && gunicorn --bind 0.0.0.0:8000 run:app
