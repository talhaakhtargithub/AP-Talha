# Use the official PyTorch base image
FROM pytorch/pytorch:latest

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory
WORKDIR /app

RUN pip install python-multipart

# Install FastAPI and other dependencies directly
RUN pip install --no-cache-dir fastapi \
    uvicorn \
    transformers \
    torch \
    opencv-python-headless \
    pydantic \
    numpy

# Copy the FastAPI application code
COPY . .

# Expose the FastAPI port
EXPOSE 8000

# Run the FastAPI app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
