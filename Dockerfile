# --- Stage 1: Builder ---
FROM python:3.9 AS builder

WORKDIR /app

# Install dependencies into a local folder
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# --- Stage 2: Final Runtime ---
FROM python:3.9-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/root/.local/bin:${PATH}"

WORKDIR /app/backend

# Copy only the installed packages from the builder stage
COPY --from=builder /root/.local /root/.local

# Copy the rest of your application code
COPY . /app/backend

EXPOSE 8000

# Using the list format for CMD is considered best practice
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
