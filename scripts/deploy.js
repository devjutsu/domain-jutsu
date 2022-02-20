const main = async () => {
    const domainContractFactory = await hre.ethers.getContractFactory('Domains');
    const domainContract = await domainContractFactory.deploy("jutsu");
    await domainContract.deployed();

    console.log("Contract deployed to:", domainContract.address);

    let txn = await domainContract.register("dev", { value: hre.ethers.utils.parseEther('0.5') });
    await txn.wait();
    console.log("Minted domain dev.jutsu");

    txn = await domainContract.setRecord("dev", "jutsu.dev");
    await txn.wait();
    console.log("Set record for dev.jutsu");

    const address = await domainContract.getAddress("dev");
    console.log("Owner of domain dev:", address);

    const balance = await hre.ethers.provider.getBalance(domainContract.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(balance));
}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();