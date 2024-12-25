# Use the official Python 3.7 base image
FROM python:3.7-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Python script into the container
COPY app.py /app/app.py

# Install Flask
RUN pip install flask

# Expose port 8080 for the Flask application
EXPOSE 8080

# Run the Python script using CMD
CMD ["python", "app.py"]
