
const cors = require("cors");
const express =require("express");
const dotenv = require("dotenv");
const connectDatabase = require("./helpers/database/connectDatabase.js");
const customErrorHandler = require("./middlewares/errors/customErrorHandler");
const path= require("path");

const routers = require("./routers/index.js");

//Environment Variables
dotenv.config({
    path : "./config/env/config.env"
});



//MongoDb Connection

connectDatabase();

const app = express();

const host = '0.0.0.0';

const PORT =process.env.PORT || 5000;
//Express - Body Middleware
app.use(cors());
app.use(express.json()); // Req body ' i json olarak almak için

// Routers Middleware

app.use("/api",routers);
app.use(customErrorHandler);

// Static Files

app.use(express.static(path.join(__dirname, "public")));
app.listen(PORT,host,() =>{
    console.log(`App Started on ${PORT} : ${process.env.NODE_ENV}`);
});