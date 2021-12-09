const express = require("express");
const {getAllRequest, getUserFromRequest,getUserToRequest,respondRequest} = require("../controllers/request.js");
const {getAccessToRoute} = require("../middlewares/authorization/auth.js");
const router = express.Router();

router.get("/",getAllRequest);
router.get("/from",getAccessToRoute,getUserFromRequest);
router.get("/to",getAccessToRoute,getUserToRequest);
router.post("/:id",respondRequest);

module.exports = router;