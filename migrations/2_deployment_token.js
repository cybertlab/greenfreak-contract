const hhtoken = artifacts.require('HHToken')


module.exports = async function (deployer, networks, accounts) {
    await deployer.deploy(
        hhtoken,

    )
}
