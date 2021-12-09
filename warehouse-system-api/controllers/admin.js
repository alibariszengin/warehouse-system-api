const User =require("../models/User");
const CustomError = require('../helpers/error/CustomError');
const asyncErrorWrapper = require("express-async-handler");

const blockUser =asyncErrorWrapper( async(req, res, next) =>{
    const {id} = req.params;
  
    const user = req.data;

    user.blocked =!user.blocked;

    await user.save();

    return res.status(200)
    .json({
        succes:true,
        message : "Block - Unblock Successfull"
    });
});
const deleteAllUsers =asyncErrorWrapper(async(req, res ,next) => {

    await User.deleteMany({}).then(function(){
        console.log("Data deleted"); // Success
    }).catch(function(error){
        next(new CustomError("All Users Deleted failed"),500);
    });
    
    return res.status(200)
    .json({
        success:true,
        message:"All Deleted"
    })
    
});
const deleteUser =asyncErrorWrapper(async(req, res ,next) => {
    
    const {id} = req.params;

    // await User.deleteOne({ _id: id}).then(function(){
    //     console.log( `User with id => ${id} deleted`); // Success
    // }).catch(function(error){
    //     next(new CustomError( `User with id => ${id} could not deleted`),500);
    // });
    const user = req.data;
    await user.remove();
    return res.status(200)
    .json({
        success:true,
        message: `User with id => ${id} deleted`
    })
    
});
module.exports={
    blockUser,
    deleteAllUsers,
    deleteUser
}