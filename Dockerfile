# Base image
FROM node:20

# Install Truffle globally
RUN npm install -g truffle

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (including OpenZeppelin Contracts)
RUN npm install

# Copy the rest of the application files
COPY . .

# Default command
CMD ["truffle", "compile"]
