const express = require("express");
const {
  register,
  getUser,
  login,
  logout,
  forgotPassword,
  resetPassword,
  editDetails,
} = require("../controllers/auth.js");
const { getAccessToRoute } = require("../middlewares/authorization/auth");


const router = express.Router();

router.post("/register", register);
router.post("/login", login);
router.get("/logout", getAccessToRoute, logout);

router.post("/forgotpassword", forgotPassword);
router.put("/resetpassword", resetPassword);

router.get("/profile", getAccessToRoute, getUser);
router.put("/edit", getAccessToRoute, editDetails);

module.exports = router;
