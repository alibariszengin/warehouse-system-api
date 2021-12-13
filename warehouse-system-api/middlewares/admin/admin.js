const CustomError = require('../../helpers/error/CustomError');
const asyncErrorWrapper = require("express-async-handler")
const User= require("../../models/User")

const checkUserAdmin = asyncErrorWrapper( async(req, res, next) =>{

    const user = await User.findById(req.user.id);
    console.log(user)
    if(user.role!=="admin"){
        return next(new CustomError("You are not authorized to access this route - Not Admin",401));
    }
    
    next();
    
    
})

module.exports = {
    checkUserAdmin
}
