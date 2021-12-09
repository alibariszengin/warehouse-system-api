const Request =require("../models/Request");
const Warehouse =require("../models/Warehouse");
const Product =require("../models/Product");
const CustomError = require('../helpers/error/CustomError');
const asyncErrorWrapper = require("express-async-handler");
const {addWarehouseProduct} = require("./product")
const getAllRequest =asyncErrorWrapper( async(req, res, next) =>{

    const allRequest = await Request.find();

    console.log(allRequest);

    return res.status(200)
    .json({
        success: true,
        data: allRequest
    });


});

const getUserFromRequest = asyncErrorWrapper( async(req, res, next) =>{

    const {id} = req.user;
    console.log(id)
    const userFromRequest = await Request.find({'from.user':id});
    // userFromRequest.find("from.warehouse._id")
  



    return res.status(200)
    .json({
        success: true,
        data: userFromRequest
    });


});
const getUserToRequest = asyncErrorWrapper( async(req, res, next) =>{

    const {id} = req.user;
    console.log(id)
    const userToRequest = await Request.find({'to.user':id});
    // userFromRequest.find("from.warehouse._id")


    return res.status(200)
    .json({
        success: true,
        data: userToRequest
    });


});

const respondRequest = asyncErrorWrapper( async(req, res, next) =>{
    const {id} = req.params;
    const {status} = req.body;

    if(status==null){
        return next(new CustomError("Provide a respond status!",400));
    }
    const request = await Request.findById(id);
    // if(request.status =="accepted" || request.status == "refused"){
    //     return next( new CustomError("This request already had been responded.",400));
    // }

 
    if(status == 1){
        console.log(request.product)
        request.status = "accepted";
        request.updatedAt = Date.now();
        let products=[];
        for(const product of (request.product)){
            const productModel = await Product.findById(product.product._id)
            console.log(productModel)
            productModel.reserved -=(Number)(product.amount);
            await productModel.save();
            const tmp = {
                name:productModel.name,
                amount : product.amount
            }
            products.push(tmp)
      
                   
     
        }
        console.log(products)
        const req ={
            body:products,
            data:request.to.warehouse
        }
            
        
        await request.save();
        return await addWarehouseProduct(req,res,next);
    }
    else if(status == 0){
        request.status = "refused";
        request.updatedAt = Date.now();
        for(const product of request.product){
            const productModel = await Product.findById(product.product._id)
            productModel.reserved -=(Number)(product.amount);
            productModel.stock +=(Number)(product.amount);
            await productModel.save();
           
        };
        await request.save();
 
        return res.status(200)
        .json({
            success:true,
            message:"Request has been refused"
        });
    }
    else{
        return next(new CustomError("Invalid status code",400));
    }

    
});
module.exports={
    getAllRequest,
    getUserFromRequest,
    getUserToRequest,
    respondRequest
}