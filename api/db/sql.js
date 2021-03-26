const sql = require('mssql');

require('dotenv').config();

var config = {
    user: process.env.BD_USER,
    password: process.env.BD_PASSWORD,
    server: process.env.HOST,
    database: process.env.DATABASE,
    options: {
        instanceName: 'SQLEXPRESS'
    }
}

function query(query, data) {
    let req = getQuery(query,data);
    return request(req);
}

function request(query) {
    return new Promise((resolve, reject) => {
        new sql.ConnectionPool(config).connect().then(pool => {
            return pool.request().query(query);
        }).then(result => {
            sql.close();
            resolve(result.recordset);
        }).catch(err => {
            sql.close();
            reject(err);
        });
    });
}

let applyFilters = (obj) => {
    let params = [];
    let hasStatus = false;

    Object.keys(obj).forEach(key=>{
        let filter;
        switch(key){
            case 'from':
                filter = `creationDate >= '${obj[key]}'`;
                break;
            case 'to':
                filter = `creationDate <= '${obj[key]}'`;
                break;
            case 'originator':
                filter = `${key} IN (SELECT username FROM users WHERE name LIKE '%${obj[key]}%' OR 
                username LIKE '%${ obj[key] }%')`;
                break;
            case 'status':
                hasStatus = true;
            default:
                filter = `${key} LIKE '%${ obj[key] }%'`;
                break;
        }
        params.push(filter);
    });

    if(!hasStatus){
        params.push(`status != 'pending'`);
    }

    if(params.length > 1){
        return ' AND ' + params.join(' AND ');
    }
    if(params.length>0){
        return ' AND ' + params[0];
    }
    return '';
}

let convertToArrayAddField = (array, value)=>{
    let newArray = [];
    for(let entrie of Object.keys(array)){
        array[entrie].request = value;
        newArray.push(array[entrie]);
    }
    return newArray;    
}

let convertToArray = (array)=>{
    let newArray = [];
    for(let entrie of Object.keys(array)){
        newArray.push(array[entrie]);
    }
    return newArray;
}

function getQuery(query, data) {
    let columns = [];
    let rows = [];
    if (!Array.isArray(data)) {
        for (var key of Object.keys(data)) {
            columns.push(key);
            let val = data[key].toString().replace(/'/g,"''");
            rows.push("'" + val + "'");

        }
        query = query.replace("()", "(" + columns.toString() + ")");
        query = query.replace("?", "(" + rows.toString() + ")");
        console.log(query);
        return query;
    } else {
        for (let [index, val] of data.entries()) {
            let row = [];
            for (let key of Object.keys(val)) {
                if (index === 0) {
                    columns.push(key);
                }
                let data = val[key].toString().replace(/'/g,"''");
                row.push("'" + data + "'");
            }
            rows.push(row);
        }
        let entries = [];
        for (let row of rows) {
            let entrie = "(" + row.toString() + ")";
            entries.push(entrie);
        }
        query = query.replace("()", "(" + columns.toString() + ")");
        query = query.replace("?", entries.toString());
        console.log(query);
        return query;
    }
}


module.exports = {
    query,
    request,
    convertToArray,
    convertToArrayAddField,
    applyFilters
};