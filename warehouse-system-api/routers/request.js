const express = require("express");
const {getAllRequest, getUserFromRequest,getUserToRequest,respondRequest,getCreateRequest,respondCreate, getDistanceBetweenWarehouses} = require("../controllers/request.js");
const {getAccessToRoute} = require("../middlewares/authorization/auth.js");
const {checkUserAdmin} = require("../middlewares/admin/admin.js");
const router = express.Router();

router.get("/",getAllRequest);
router.get("/from",getAccessToRoute,getUserFromRequest);
router.get("/to",getAccessToRoute,getUserToRequest);
router.post("/:id",respondRequest);
router.get("/admin",getAccessToRoute,checkUserAdmin,getCreateRequest);
router.post("/admin/:id",getAccessToRoute,checkUserAdmin,respondCreate);

router.get("/distance/:from/:to",getDistanceBetweenWarehouses);
module.exports = router;