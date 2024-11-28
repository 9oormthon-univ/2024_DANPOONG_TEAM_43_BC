# Base image
FROM node:20

# Install essential tools
RUN apt-get update && apt-get install -y git bash

# Install Truffle and Ganache CLI globally
RUN npm install -g truffle ganache-cli

# Add global npm binaries to PATH
ENV PATH="/usr/local/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install project dependencies
RUN npm install

# Expose Ganache port
EXPOSE 7545

# Default command: keep container alive for manual debugging
CMD ["bash"]
