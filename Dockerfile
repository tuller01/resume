# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /app

# Install git and nginx
RUN apt-get update && apt-get install -y git nginx sqlite3

# Clone the repository
RUN git clone https://github.com/tuller01/resume.git .

# Create the git_pull script
RUN echo '#!/bin/sh\\nwhile true; do git pull; sleep 300; done' > /app/git_pull.sh && chmod +x /app/git_pull.sh

# Create the database.py script
RUN echo 'import sqlite3' > /app/database.py && \
    echo 'def init_db():' >> /app/database.py && \
    echo "    conn = sqlite3.connect('database.db')" >> /app/database.py && \
    echo '    print("Opened database successfully")' >> /app/database.py && \
    echo "    conn.execute('CREATE TABLE IF NOT EXISTS messages (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, message TEXT, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)')" >> /app/database.py && \
    echo '    print("Table created successfully")' >> /app/database.py && \
    echo '    conn.close()' >> /app/database.py

# Initialize the database
RUN python3 -c 'from database import init_db; init_db()'

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy nginx config
RUN cp nginx.conf /etc/nginx/sites-available/default

# Make port 80 available to the world outside this container
EXPOSE 80

# Start Gunicorn, Nginx, and the git_pull script
CMD service nginx start && /app/git_pull.sh & gunicorn --bind 0.0.0.0:8000 --reload run:app
