const Sql = require('../db/sql.js');

exports.updateBackups = async (req, res) => {
    try {
        let user = req.params.user;
        let body = req.body.backups;

        // let body = data.map(d => ({
        //     lender: user,
        //     granted: d
        // }));

        console.log(body);

        let query = `DELETE FROM backups WHERE lender = '${user}'`;

        await Sql.asyncRequest(query);

        query = `INSERT INTO backups() VALUES ?`;

        await Sql.asyncQuery(query,body);

        res.json({
            ok: true
        });

    } catch (e) {
        console.log(e);
        return res.json({
            ok: false,
            message: e
        });
    }
}

exports.getBackups = async (req, res) => {
    try {
        let user = req.params.user;

        let query = `SELECT username, name, email, position 
        FROM users WHERE username = '${user}'`;

        let userInfo = await Sql.request(query);

        query = `SELECT username, name, email, position, CAST(enabled as NUMERIC) as enabled
        FROM users, backups 
        WHERE lender = '${user}' 
        AND users.username = backups.granted`;

        let backups = await Sql.request(query);

        return res.json({
            ok: true,
            user: userInfo[0],
            backups: backups
        });

    } catch (e) {
        console.log(e);
        return res.json({
            ok: false,
            message: e
        });
    }
}

exports.updateManagers = async (req, res) => {
    try {
        let body = req.body.managers;
        let calls = [];

        let query = `UPDATE users 
        SET position = 'employee'
        WHERE position LIKE '%manager%'`;

        await Sql.asyncRequest(query);

        body.forEach(m => {
            let query = `UPDATE users SET 
            position = '${m['position']}'
            WHERE username = '${m['username']}'`;

            calls.push(Sql.request(query));
        });

        return res.json({
            ok: true
        });
    } catch (e) {
        console.log(e);
        return res.json({
            ok: false,
            message: e
        });
    }
}