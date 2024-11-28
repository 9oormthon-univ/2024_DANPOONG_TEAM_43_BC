module.exports = {
  contracts_directory: "./contracts", // Solidity 파일이 위치한 경로
  contracts_build_directory: "./build/contracts", // 컴파일된 파일 저장 경로
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
      version: "0.8.20",  // Ensure the Solidity version matches your contracts
    },
  },
};
