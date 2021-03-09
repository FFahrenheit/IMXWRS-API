var Waivers = require('../controllers/waivers.controller');

module.exports = (app) => {
    app.route('/waivers')
    .get(Waivers.getData)
    .post(Waivers.createWaviver);

    app.route('/waivers/authorizations').
    get(Waivers.getAuthorizations);
}