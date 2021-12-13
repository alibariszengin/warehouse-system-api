const Request = require("../../models/Request");
const Product = require("../../models/Product");
const Warehouse = require("../../models/Warehouse");
const CustomError = require("../../helpers/error/CustomError");
const asyncErrorWrapper = require("express-async-handler");


const checkHasEnoughProduct =asyncErrorWrapper(async(req, res ,next) => {

    const {products}= req.body;
    const {from,to} = req.params;
    const warehouse = await Warehouse.findById(from).populate("products");
    const warehouseTo = await Warehouse.findById(to).populate("products");
    console.log(warehouse.products)
    if((!warehouse) || (!warehouseTo) ){
        return next(new CustomError("There is no such warehouse with that id",400));
    }

    const request = await Request.create({
        from : {warehouse :warehouse,user: req.user.id},
        to : {warehouse :to, user : warehouseTo.user},
        type: "transport"
         
    });

    
   
    for (const [key, value] of Object.entries(products)) {
        console.log("1")
        const tmp =warehouse.products.find((item)=>item.name==key);
           
               
        if(!tmp){
            await Request.findByIdAndRemove(request._id, function(err){
                if(err){
                    console.log("Request couldn't delete");
                } 
             });
            return next( new CustomError("Warehouse does not have that product",400));
        }
        
        if(tmp.stock < value){
            await Request.findByIdAndRemove(request._id, function(err){
                if(err){
                    console.log("Request couldn't delete");
                } 
             });
            return next( new CustomError("Warehouse does not have that number of product",400));
            
        }
        
        
        request.product.push({product:tmp,amount:value});

        await request.save();
        
        const product = await Product.findOne({"name":tmp.name,"warehouse":warehouse}, function (err, docs) {
            if (err){
                console.log(err)
            }
            else{
                console.log("Result : ", docs);
                return docs;
            }
        });
  
        product.stock-=value;
        product.reserved+=Number(value);
    
        await product.save();
        
        
       
            
    }
    

    req.request = request;
    req.from = warehouse;
    next();

});

module.exports={
    checkHasEnoughProduct
}