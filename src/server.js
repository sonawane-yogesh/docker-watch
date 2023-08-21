let express = require("express");
let app = express();
let maths = require("./calculator");
app.get("/", function (request, response, next) {
    response.status(200).json({ message: "App is up and running!" }).end();
});
app.get("/add", function (request, response) {
    let sum = maths.add(2, 5);
    response.status(200).json({ data: sum }).end();
});
app.get("/subtract", function (request, response) {
    let subtract = maths.subtract(6, 9);
    response.status(200).json({ data: subtract }).end();
});
app.listen(8080, function () {
    console.log("Server is up and running now on port: 8080");
});