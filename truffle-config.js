module.exports = {
  networks: {
    development: {
      host: "host.docker.internal",  // Use host.docker.internal for Docker
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
