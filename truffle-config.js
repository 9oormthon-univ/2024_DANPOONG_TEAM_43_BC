const axios = require('axios');

// Ganache에서 network_id 가져오기
async function getNetworkId() {
  try {
    const response = await axios.post('http://localhost:7545', {
      jsonrpc: '2.0',
      method: 'eth_chainId',
      params: [],
      id: 1
    });
    return response.data.result; // network_id (예: "0x539")
  } catch (error) {
    console.error('Failed to get network_id from Ganache:', error);
    return "*"; // 기본값으로 "*"을 사용하여 모든 네트워크를 허용
  }
}

module.exports = async function () {
  const networkId = await getNetworkId();

  return {
    networks: {
      development: {
        host: "0.0.0.0",
        port: 7545,
        network_id: networkId, // 동적으로 network_id 설정
      },
    },
    compilers: {
      solc: {
        version: "0.8.20",
      },
    },
  };
};
