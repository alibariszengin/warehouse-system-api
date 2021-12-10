const User = require("../../models/User");
const Warehouse = require("../../models/Warehouse");
const CustomError = require("../../helpers/error/CustomError");
const asyncErrorWrapper = require("express-async-handler");
const mongodb = require("mongodb");

const checkUserExist =asyncErrorWrapper(async(req, res ,next) => {

    const {id} = req.params;

    const user = await User.findById(id);

    if(!user){
        return next(new CustomError("There is no such user with that id",400));
    }
    req.data = user;
    next();

});
const checkWarehouseExist =asyncErrorWrapper(async(req, res ,next) => {

    const {warehouseId} = req.params;
    console.log(warehouseId)
    try{
        mongodb.ObjectId(warehouseId);
    }
    catch(err){
        return next(new CustomError("Please provide a valid id ",400));
    }
    const warehouse = await Warehouse.findById(warehouseId);
    
    if(!warehouse){
        return next(new CustomError("There is no such warehouse with that id",400));
    }
    req.data = warehouse;

    next();

});
module.exports={
    checkUserExist,
    checkWarehouseExist
}