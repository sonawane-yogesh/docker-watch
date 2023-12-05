let express = require("express");
let app = express();
let maths = require("./calculator");
app.use((request, response, next) => {
    console.log(`---==== ${request.url} ====---`);
    next();
});
let chalk = require("chalk");
app.get("/", function (request, response, next) {
    response.status(200).json({ message: "App is up and running!!!" }).end();
});
app.get("/add", function (request, response) {
    let sum = maths.add(2, 5);
    response.status(200).json({ data: sum }).end();
});
app.get("/subtract", function (request, response) {
    let subtract = maths.subtract(6, 9);
    response.status(200).json({ data: subtract }).end();
});

let port = 4000;
app.listen(port, function () {
    var address = this.address();
    var dt = new Date().toLocaleString("en-us")
    console.log(chalk.red("Restarted app: " + chalk.green(dt)));
    console.log(`Kafka server application is up running on port: ${port}`);
    console.log(JSON.stringify(address));
    console.log('=======================================================================');
});