var Sql = require('../db/sql.js');

exports.getData = (req,res)=>{
    var query = "SELECT * FROM users";
    let promise = Sql.request(query);
    promise.then(result=>{
        res.json({
            req : req.query ,
            status: result
        });
    },error =>{
        res.send(error);
    });
}