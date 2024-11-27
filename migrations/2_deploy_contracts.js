const VolunteerSessionManager = artifacts.require("VolunteerSessionManager");

module.exports = async function (deployer) {
  // VolunteerSessionManager만 배포
  await deployer.deploy(VolunteerSessionManager);
};
