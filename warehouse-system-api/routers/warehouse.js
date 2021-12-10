const express = require("express");
const {getAllWarehouses,getWarehouseInfo,searchWarehouse,getUserWarehouses,addWarehouse,deleteWarehouse} = require("../controllers/warehouse.js");

const {getAccessToRoute} = require("../middlewares/authorization/auth");

const {checkWarehouseExist} = require("../middlewares/database/databaseErrorHelpers");

const router = express.Router()

router.get("/",getAccessToRoute,getUserWarehouses);
router.post("/",getAccessToRoute,addWarehouse);

router.get("/all",getAllWarehouses);

router.get("/:warehouseId",getAccessToRoute,getWarehouseInfo);
router.delete("/:warehouseId",getAccessToRoute,checkWarehouseExist,deleteWarehouse);

router.post("/search",searchWarehouse);



module.exports = router;