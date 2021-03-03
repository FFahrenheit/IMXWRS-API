var Users = require('../controllers/user.controller');

const token = require('./../middlewares/authentication');

module.exports = (app) => {
    app.route('/users')
    .post([token.verifyUser],Users.getData)
    .get(Users.getData);
}