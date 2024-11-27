# Base image
FROM node:20

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies
RUN npm install -g truffle
RUN npm install

# Expose Ganache default port
EXPOSE 8545

# Default command
CMD ["ganache-cli", "-h", "0.0.0.0"]
