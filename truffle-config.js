module.exports = {
  contracts_directory: "./contracts", // Solidity 파일 위치
  contracts_build_directory: "./build/contracts", // 컴파일된 파일 저장 경로
  networks: {
    development: {
      host: "127.0.0.1",  // Ganache 컨테이너와 연결
      port: 7545,         // Ganache 기본 포트
      network_id: "*",    // 모든 네트워크와 호환
      networkCheckTimeout: 30000, // 네트워크 체크 타임아웃 설정
    },
  },
  compilers: {
    solc: {
      version: "0.8.20", // OpenZeppelin과 호환되는 Solidity 버전
    },
  },
};
