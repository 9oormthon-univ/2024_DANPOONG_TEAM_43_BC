module.exports = {
  compilers: {
    solc: {
      version: "0.8.21", // Specify the Solidity version here
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  }
};
