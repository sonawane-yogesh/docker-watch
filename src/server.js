const express = require("express");
const app = express();
const maths = require("./calculator");
const chalk = require("chalk");
const cors = require("cors");
const dotenv = require("dotenv");
/*
const http2 = require("http2");
const { join, resolve } = require("path");
const { readFileSync } = require("fs");
*/
dotenv.config();

app.use(cors());

app.use((request, response, next) => {
    const dt = new Date().toLocaleString("en-us")
    console.log(`---=== [${chalk.yellow(dt)}] # ${chalk.green(request.url)} ===---\n`);
    next();
});

app.get("/", function (request, response) {
    response.status(200).json({ message: "App is up and running!!!" }).end();
});
app.get("/add/:a/:b", function (request, response) {
    try {
        const a = parseInt(request.params.a);
        const b = parseInt(request.params.b);
        const sum = maths.add(a, b);
        response.status(200).json({ data: sum }).end();
    } catch (error) {
        response.status(500).json(error).end();
    }    
});
app.get("/subtract/:a/:b", function (request, response) {
    const a = parseInt(request.params.a);
    const b = parseInt(request.params.b);
    const subtract = maths.subtract(a, b);
    response.status(200).json({ data: subtract }).end();
});
app.get("/multiply/:a/:b", function (request, response) {
    const a = parseInt(request.params.a);
    const b = parseInt(request.params.b);
    const multiply = maths.multiply(a, b);
    response.status(200).json({ data: multiply }).end();
});
app.get("/divide/:a/:b", function (request, response) {
    const a = parseInt(request.params.a);
    const b = parseInt(request.params.b);
    const divide = maths.divide(a, b);
    response.status(200).json({ data: divide }).end();
});
/*
const crtPath = resolve(join(__dirname, "..", 'certificates'));
console.log(crtPath);
const httpOptions = {
    cert: readFileSync(join(crtPath, 'device.crt')),
    key: readFileSync(join(crtPath, 'device.key')),
    allowHTTP1: true,
    ALPNProtocols: ["h2"]
};
const http2Server = http2.createSecureServer(httpOptions, app);
*/
process.on("uncaughtException", (err) => {
    console.log(err); 
});

const port = parseInt(process.env.PORT, 10);
app.listen(port, function () {
    var address = this.address();
    var dt = new Date().toLocaleString("en-us")
    console.log('=======================================================================');
    console.log(chalk.red("Restarted app: " + chalk.green(dt)));
    console.log(`Server application is up running on port: ${port}`);
    console.log(JSON.stringify(address));
    console.log('=======================================================================');
});

module.exports = app;