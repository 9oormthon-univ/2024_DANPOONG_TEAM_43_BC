module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",  // Use host.docker.internal for Docker
      port: 7545,                    // Ganache's default port
      network_id: "*",               // Match any network id
    },
  },
  compilers: {
    solc: {
      version: "0.8.21",  // Ensure your Solidity version matches the pragma in your contracts
    },
  },
};
