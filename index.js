var express = require('express'),
    app = express(),
    port = process.env.PORT || 3300,
    bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var userRoutes = require('./api/routers/user.routes');
var waiverRoutes = require('./api/routers/waiver.routes');
var authRoutes = require('./api/routers/auth.routes');

app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    res.header('Access-Control-Allow-Methods', 'PUT, POST, GET, DELETE, OPTIONS');
    next();
});

userRoutes(app);
waiverRoutes(app);
authRoutes(app);

app.listen(port,()=>{
    console.log('Server running in port ' + port)
});