const Positions = require('../controllers/position.controller');
const Token = require('../middlewares/authentication');

module.exports = (app) =>{
    app.route('/position')
    .put([Token.verifyUser], Positions.updateManagers);

    app.route('/position/:user')
    .get(Positions.getBackups)
    .post(Positions.updateBackups);
}