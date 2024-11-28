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

# Clone Git repository
RUN git clone https://github.com/your-repo/your-project.git /app

# Install project dependencies
RUN npm install

# Expose Ganache port
EXPOSE 7545

# Default command to run Ganache and Truffle
CMD ["sh", "-c", "ganache-cli --host 0.0.0.0 --port 7545 & truffle compile && truffle migrate --network development"]
