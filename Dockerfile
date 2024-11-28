# Base image
FROM node:20

# Install Truffle globally
RUN npm install -g truffle

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Install OpenZeppelin Contracts explicitly
RUN npm install @openzeppelin/contracts

# Copy the rest of the application files
COPY . .
