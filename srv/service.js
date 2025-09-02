const cds = require('@sap/cds');
const {loginCheck}  = require("./login/login")

module.exports= (srv) => {
    srv.on('loginCheck', loginCheck); 

}