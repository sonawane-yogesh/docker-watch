/*
import axios from "axios";
import { isEmpty } from "lodash";
import config from "../src/configurations";
var Jwt = require('jsonwebtoken');
let axiosBody = {
    tenant: 6,
    secret: config.tenantSecret
}
*/
// this could be third party token like ping identity
let token = "test-token";
module.exports = function getToken() {
    if (!isEmpty(token)) return token;
    // token = Jwt.sign({ user: axiosBody }, config.secretKey).toString();    
    // return token;
}