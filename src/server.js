const express = require("express");
const app = express();
const maths = require("./calculator");
const chalk = require("chalk");
const cors = require("cors");
const http2 = require("http2");
const dotenv = require("dotenv");
const { join, resolve } = require("path");
const { readFileSync } = require("fs");
dotenv.config();

app.use(cors());

app.use((request, response, next) => {
    const dt = new Date().toLocaleString("en-us")
    console.log(`---=== [${chalk.yellow(dt)}] # ${chalk.green(request.url)} ===---\n`);
    next();
});

app.get("/", function (request, response, next) {
    response.status(200).json({ message: "App is up and running!!!" }).end();
});
app.get("/add/:a/:b", function (request, response) {
    const a = parseInt(request.params.a);
    const b = parseInt(request.params.b);
    const sum = maths.add(a, b);
    response.status(200).json({ data: sum }).end();
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
    const subtract = maths.multiply(a, b);
    response.status(200).json({ data: subtract }).end();
});
app.get("/divide/:a/:b", function (request, response) {
    const a = parseInt(request.params.a);
    const b = parseInt(request.params.b);
    const divide = maths.divide(a, b);
    response.status(200).json({ data: divide }).end();
});
const crtPath = resolve(__dirname, "../", 'certificates');
const http2Server = http2.createSecureServer({
    cert: readFileSync(join(crtPath, 'device.crt')),
    key: readFileSync(join(crtPath, 'device.key')),
    allowHTTP1: true,
    ALPNProtocols: ["h2"]

}, app);
const port = process.env.PORT;
http2Server.listen(port, function () {
    var address = this.address();
    var dt = new Date().toLocaleString("en-us")
    console.log('=======================================================================');
    console.log(chalk.red("Restarted app: " + chalk.green(dt)));
    console.log(`Server application is up running on port: ${port}`);
    console.log(JSON.stringify(address));
    console.log('=======================================================================');
});

module.exports = app;