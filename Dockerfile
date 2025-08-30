# Use the official Node.js image (updated to a more recent version)
FROM node:20-slim

# Set the working directory for the app
WORKDIR /app

# Install required dependencies (Python, build-essential, etc.)
RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy package.json files and install dependencies for frontend
WORKDIR /app/portal
COPY app/portal/package*.json ./
RUN npm install

# Copy all frontend files
COPY app/portal/ .

# Build the frontend
RUN npm run build

# Switch to the backend directory
WORKDIR /app/srv
COPY gen/srv/package*.json ./

# Install backend dependencies
RUN npm ci

# Copy all backend files
COPY gen/srv/ .

# Expose the app's port (if applicable)
EXPOSE 3000

# Start the backend service (modify as per your app's start command)
CMD ["npm", "start"]
