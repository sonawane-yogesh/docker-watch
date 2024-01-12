let express = require("express");
let app = express();
let maths = require("./calculator");
let chalk = require("chalk");
let cors = require("cors");

app.use(cors());

app.use((request, response, next) => {
    let dt = new Date().toLocaleString("en-us")
    console.log(`---=== [${chalk.yellow(dt)}] # ${chalk.green(request.url)} ===---\n`);
    next();
});

app.get("/", function (request, response, next) {
    response.status(200).json({ message: "App is up and running!!!" }).end();
});
app.get("/add/:a/:b", function (request, response) {
    let a = parseInt(request.params.a);
    let b = parseInt(request.params.b);
    let sum = maths.add(a, b);
    response.status(200).json({ data: sum }).end();
});
app.get("/subtract/:a/:b", function (request, response) {
    let a = parseInt(request.params.a);
    let b = parseInt(request.params.b);
    let subtract = maths.subtract(a, b);
    response.status(200).json({ data: subtract }).end();
});
app.get("/multiply/:a/:b", function (request, response) {
    let a = parseInt(request.params.a);
    let b = parseInt(request.params.b);
    let subtract = maths.multiply(a, b);
    response.status(200).json({ data: subtract }).end();
});
app.get("/divide/:a/:b", function (request, response) {
    let a = parseInt(request.params.a);
    let b = parseInt(request.params.b);
    let divide = maths.divide(a, b);
    response.status(200).json({ data: divide }).end();
});

let port = 4000;
app.listen(port, function () {
    var address = this.address();
    var dt = new Date().toLocaleString("en-us")
    console.log('=======================================================================');
    console.log(chalk.red("Restarted app: " + chalk.green(dt)));
    console.log(`Kafka server application is up running on port: ${port}`);
    console.log(JSON.stringify(address));
    console.log('=======================================================================');
});

module.exports = app;