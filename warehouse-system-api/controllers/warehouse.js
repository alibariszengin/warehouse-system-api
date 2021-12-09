const Warehouse = require("../models/Warehouse");
const asyncErrorWrapper = require("express-async-handler");
const CustomError = require("../helpers/error/CustomError");
const Request = require("../models/Request");
const User = require("../models/User");
const mongodb = require("mongodb");
const createWarehouse = asyncErrorWrapper(async (req, res, next) => {
  // POST DATA

  const { name, email, password, role } = req.body;
  // async,await

  const warehouse = await Warehouse.create({
    ...req.body,
  });
  return res.status(200).json({
    success: true,
    data: warehouse,
  });
});

const getAllWarehouses = asyncErrorWrapper(async (req, res, next) => {
  const warehouses = await Warehouse.find().populate("user");

  return res.status(200).json({
    success: true,
    data: warehouses,
  });
});

const getWarehouseInfo = asyncErrorWrapper(async (req, res, next) => {
  const { warehouseId } = req.params;
  const warehouse = await Warehouse.findById(warehouseId);

  console.log(warehouse);
  return res.status(200).json({
    success: true,
    data: warehouse,
  });
});

const getUserWarehouses = asyncErrorWrapper(async (req, res, next) => {
  const { id } = req.user;
  console.log(id);
  const user = await User.findById(id).populate("warehouses");

  return res.status(200).json({
    success: true,
    data: user.warehouses,
  });
});

const addWarehouse = asyncErrorWrapper(async (req, res, next) => {
  // const {id} = req.params;

  const user = await User.findById(req.user.id);
  console.log(user);
  if (Object.keys(req.body).length === 0) {
    return next(new CustomError("There is no warehouse info", 400));
  }

  const warehouse = await Warehouse.create({
    ...req.body,
  });
  warehouse.user = user._id;
  await warehouse.save();
  console.log(warehouse);
  user.warehouses.push(warehouse.populate("user"));
  await user.save();
  console.log(user.warehouses);

  return res.status(200).json({
    success: true,
    data: warehouse,
  });
});

const deleteWarehouse = asyncErrorWrapper(async (req, res, next) => {
  // const {id} = req.params;
  const { warehouseId } = req.params;
  const userId = req.data.user;
  
  console.log(userId);
  const user = await User.findById(userId);

  let userWarehouses = user.warehouses;
  var filtered = userWarehouses.filter(function (value, index, arr) {
    return value._id != warehouseId;
  });
  user.warehouses = filtered;
  await user.save();
  await Warehouse.deleteOne(
    { _id: mongodb.ObjectId(warehouseId) },
    function (err, obj) {
      if (err) {
        return next(CustomError("Depo could not deleted..."));
      }
    }
  );

  return res.status(200).json({
    success: true,
    message: `Warehouse with that ${warehouseId} is deleted`,
  });
});

const searchWarehouse = asyncErrorWrapper(async (req, res, next) => {
  const { search } = req.body;
  let warehouses = await Warehouse.find();
  console.log(search);
  if (!search) {
    return next(new CustomError("Please provie a search info", 400));
  }
  warehouses = warehouses.filter((warehouse) => {
    return (
      warehouse.name.includes(search) ||
      warehouse.address.includes(search) ||
      warehouse.title.includes(search)
    );
  });

  return res.status(200).json({
    success: true,
    data: warehouses,
  });
});

module.exports = {
  createWarehouse,
  getAllWarehouses,
  getWarehouseInfo,
  searchWarehouse,
  getUserWarehouses,
  addWarehouse,
  deleteWarehouse,
};
