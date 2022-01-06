/**
 * Use this file to configure your truffle project. It's seeded with some
 * common settings for different networks and features like migrations,
 * compilation and testing. Uncomment the ones you need or modify
 * them to suit your project as necessary.
 *
 * More information about configuration can be found at:
 *
 * truffleframework.com/docs/advanced/configuration
 *
 * To deploy via Infura you'll need a wallet provider (like @truffle/hdwallet-provider)
 * to sign your transactions before they're sent to a remote public node. Infura accounts
 * are available for free at: infura.io/register.
 *
 * You'll also need a mnemonic - the twelve word phrase the wallet uses to generate
 * public/private key pairs. If you're publishing your code to GitHub make sure you load this
 * phrase from a file you've .gitignored so it doesn't accidentally become public.
 *
 */

require("dotenv").config();
const HDWalletProvider = require('@truffle/hdwallet-provider');
// const HDWalletProvider = require('@truffle/hdwallet-provider');
// const infuraKey = "fj4jll3k.....";
//
// const fs = require('fs');
// const mnemonic = fs.readFileSync(".secret").toString().trim();
const dotenv = require('dotenv');
dotenv.config();

module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. If you don't specify one truffle
   * will spin up a development blockchain for you on port 9545 when you
   * run `develop` or `test`. You can ask a truffle command to use a specific
   * network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */

  plugins: [
    'truffle-plugin-verify'
  ],
  api_keys: {
    etherscan: process.env.API_KEY
  },

  networks: {
    rinkeby: {

      enableTimeouts: false,
      network_id: 4,       // Any network (default: none)

      provider: () => new HDWalletProvider(process.env.PRIVATE_KEY_KOVAN, "https://rinkeby.infura.io/v3/043e74aaf32544e6bceb3eb06dd98176"),
      //accounts: 0,

    },
    kovan: {
      networkCheckTimeout: 10000,
      // provider: () => new PrivateKeyProvider(process.env.KOVAN_privateKey, "https://kovan.infura.io/v3/043e74aaf32544e6bceb3eb06dd98176"),
      provider: () => new HDWalletProvider(process.env.PRIVATE_KEY_KOVAN, "https://mainnet.infura.io/v3/043e74aaf32544e6bceb3eb06dd98176"),

      network_id: 42,
      from: process.env.KOVAN_account,
      gas: 8000000,
      skipDryRun: true,
      confirmations: 0
    },
    // mainnet:{
    //
    //   port: 8545, // Standard Ethereum port (default: none)
    //   //networkCheckTimeout: 10000,
    //   // provider: () => new PrivateKeyProvider(process.env.KOVAN_privateKey, "https://kovan.infura.io/v3/043e74aaf32544e6bceb3eb06dd98176"),
    //   provider: () => new HDWalletProvider(process.env.MAIN_KEY_LOCAL, "https://mainnet.infura.io/v3/043e74aaf32544e6bceb3eb06dd98176"),
    //
    //   network_id: "1",
    //
    //   //gas: 500000000000, // per gas used when deployed in test
    //   gasPrice: 30000000000, // 132 gwei (current cost in eth station)
    //   skipDryRun: true,
    //
    // }


  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.7",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    },
  },
};
