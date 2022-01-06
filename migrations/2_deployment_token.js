const GreenFreak = artifacts.require('GreenFreak')


module.exports = async function (deployer, networks, accounts) {
    await deployer.deploy(
        GreenFreak,
        "GreenFreak",
        "GFOM",
        "https://gateway.pinata.cloud/ipfs/QmUVNGUcrs3wMFJKYntYqrm1xSr7x5C6EhdexoPNC1wMeQ"

    )
}
