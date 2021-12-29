const User = require("../models/User");
const Warehouse  = require("../models/Warehouse")
const Product  = require("../models/Product")
const CustomError = require("../helpers/error/CustomError");
const asyncErrorWrapper = require("express-async-handler");
const { sendJwtToClient } = require("../helpers/authorization/tokenHelpers.js");
const { validateUserInput, comparePassword} = require("../helpers/input/inputHelpers.js");
const { htmlEmailTemplate} = require("../helpers/authorization/emailHelpers.js");
const sendEmail = require("../helpers/libraries/sendEmail");

const register =asyncErrorWrapper(async(req, res ,next) => {
    // POST DATA
    
    const {name, email, password } = req.body;
    // async,await 
   
    const user = await User.create({
        ...req.body
     
    });
    sendJwtToClient(user, res);
    
});

const login = asyncErrorWrapper(async(req, res ,next) => {

    const {email, password} = req.body;
    console.log(email,password);


    if(!validateUserInput(email,password)){
        return next(new CustomError("Please check your inputs",400));
    }

    const user= await User.findOne({email}).select("+password");
    if(!user){
        return next( new CustomError("Please check your email",400))
    }
    if(!comparePassword(password,user.password)){
        return next(new CustomError("Please check your credentials",400));
    }


    sendJwtToClient(user, res);
});

const logout =asyncErrorWrapper(async(req, res ,next) =>{

    const {NODE_ENV} = process.env;

    return res.status(200)
    .cookie({
        httpOnly:true,
        expires: new Date(Date.now()),
        secure: NODE_ENV ==="development" ? false :true
    }).json({
        success:true,
        message:"Logout Successfull"
    })
});

const getUser= asyncErrorWrapper(async(req, res ,next) => {
    const user = await User.findById(req.user.id);
    return res.status(200)
    .json({
        success:true,
        data: user
   
    })
});


// Forgot Password
const forgotPassword=asyncErrorWrapper(async(req, res ,next) =>{

    const resetEmail = req.body.email;
    console.log(resetEmail)
    const user = await User.findOne({email : resetEmail});
    console.log("2")
    if(!user){
        return next(new CustomError("There is no user with that email",400));
    }
    console.log("3")
    const resetPasswordToken = user.getResetPasswordTokenFromUser();
    await user.save();
    console.log("4")
    const resetPasswordUrl = `https://api.myapp.com/redirect?url=warehouse://warehouse-system-api.herokuapp.com/api/auth/resetpassword?resetPasswordToken=${resetPasswordToken}`
    console.log("5")
    const emailTemplate = htmlEmailTemplate(resetPasswordUrl)
    try{
        await sendEmail({
            from : process.env.SMTP_USER,
            to : resetEmail,
            subject: "Reset Your Password",
            html : emailTemplate
        });
        console.log("7")
        return res.status(200).json({
            success:true,
            message:"Token Sent To Your Email"
        });
    }
    catch(err){
        
        user.resetPasswordToken=undefined;
        user.resetPasswordExpire=undefined;

        await user.save();

        return next(new CustomError("Email Could Not Be Sent",500));
    }
    
  
});

const resetPassword =asyncErrorWrapper(async(req, res ,next) =>{
    const {resetPasswordToken} = req.query;

    const {password} = req.body;

    if(!resetPasswordToken){
        return next(new CustomError("Please provide a valid token",400));
    }

    let user = await User.findOne({
        resetPasswordToken:resetPasswordToken,
        resetPasswordExpire : {$gt : Date.now()}
    });

    if(!user){
        return next(new CustomError("Invalid Token or Session Expired",404))
    }
    user.password = password;
    user.resetPasswordToken = undefined;
    user.resetPasswordExpire = undefined;

    await user.save();
    return res.status(200)
    .json({
        success:true,
        message:" Reset Password Process Successfull"
    })
});

const editDetails = asyncErrorWrapper(async(req, res ,next) =>{

    const editInformation = req.body;

    const user = await User.findByIdAndUpdate(req.user.id,editInformation,{
        new :true,
        runValidators:true
    });

    return res.status(200)
    .json({
        success:true,
        data : user
    });

});




module.exports = {
    register,
    login,
    logout,
    getUser,
    forgotPassword,
    resetPassword,
    editDetails,
  

}