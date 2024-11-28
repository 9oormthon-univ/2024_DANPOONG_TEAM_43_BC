# Base image
FROM node:20

# Install Truffle globally
RUN npm install -g truffle

# Set working directory
WORKDIR /app

# Copy project files to container
COPY . .

# Install project dependencies and OpenZeppelin Contracts
RUN npm install && npm install @openzeppelin/contracts
