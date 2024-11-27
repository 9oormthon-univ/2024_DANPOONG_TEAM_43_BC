module.exports = {
  networks: {
    development: {
      host: "0.0.0.0",     // Localhost
      port: 7545,            // Default port for Ganache
      network_id: "*",       // Match any network id
    },
  },
  compilers: {
    solc: {
      version: "0.8.21", // Ensure your Solidity version matches the pragma in your contracts
    },
  },
};
