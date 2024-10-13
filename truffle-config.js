module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",      // Localhost (default: none)
      port: 7545,             // Ganache GUI default port
      network_id: "5777",        // Match any network id (use * for local development)
    },
  },
  compilers: {
    solc: {
      version: "0.8.13",      // Specify the Solidity version
    },
  },
};
