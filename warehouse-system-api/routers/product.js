const express = require("express");

const{ 
    getAllProduct,
    getWarehouseProduct,
    addWarehouseProduct,
    transferProduct
}= require("../controllers/product.js");
const {checkHasEnoughProduct} = require("../middlewares/warehouse/warehouse");

const {getAccessToRoute} = require("../middlewares/authorization/auth");
const {checkWarehouseExist} = require("../middlewares/database/databaseErrorHelpers");

const router = express.Router()
router.get("/",getAllProduct);
router.get("/:warehouseId",getAccessToRoute,checkWarehouseExist,getWarehouseProduct);
router.post("/:warehouseId",getAccessToRoute,checkWarehouseExist,addWarehouseProduct);
router.post("/:from/:to",getAccessToRoute,checkHasEnoughProduct,transferProduct);
module.exports = router;