module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",  // Use localhost IP address
      port: 7545,          // Ganache's default port
      network_id: "*",     // Match any network id
      networkCheckTimeout: 30000,  // Set a longer timeout (30 seconds)
    },
  },
  compilers: {
    solc: {
      version: "0.8.21",  // Ensure the Solidity version matches your contracts
    },
  },
};
