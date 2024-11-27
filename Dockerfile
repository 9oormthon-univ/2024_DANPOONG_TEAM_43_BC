# Base image
FROM node:20

# Install Truffle globally
RUN npm install -g truffle

# Set working directory
WORKDIR /app

# Copy files
COPY . .

# Install dependencies
RUN npm install
