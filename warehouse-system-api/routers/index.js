const express = require('express');

const auth = require("./auth");
const user = require("./user");
const admin = require("./admin");
const warehouse = require("./warehouse");
const product = require("./product");
const request = require("./request");

// /api
const router = express.Router();


router.use("/auth",auth);
router.use("/users",user);
router.use("/admin",admin);
router.use("/warehouses",warehouse);
router.use("/products",product);
router.use("/request",request);

module.exports = router;