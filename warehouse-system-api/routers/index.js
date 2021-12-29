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
router.get("/redirect/:token",function(req,res){
    // On getting the home route request,
    // the user will be redirected to GFG website
    const {token} = req.params;
    res.redirect(`warehouse://warehouse-system-api.herokuapp.com/api/auth/resetpassword?resetPasswordToken=${token}`);
  });
    
module.exports = router;