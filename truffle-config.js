module.exports = {
  contracts_directory: "./contracts",
  contracts_build_directory: "./build/contracts",
  networks: {
    development: {
      host: "ganache", // Docker Compose의 서비스 이름
      port: 7545,      // Ganache 컨테이너의 포트
      network_id: "*", // 모든 네트워크와 호환
    },
  },
  compilers: {
    solc: {
      version: "0.8.20", // Solidity 버전
    },
  },
};
