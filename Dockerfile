# Base image
FROM node:20

# Install Truffle and Ganache CLI globally
RUN npm install -g truffle ganache-cli

# Add global npm binaries to PATH
ENV PATH="/usr/local/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Expose Ganache port
EXPOSE 7545

# Use an entrypoint script for Ganache and Truffle
CMD ["sh", "-c", "ganache-cli --host 0.0.0.0 --port 7545 & truffle compile && truffle migrate --network development"]
