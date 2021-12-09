const Product = require("../models/Product");
const Warehouse = require("../models/Warehouse");
const CustomError = require("../helpers/error/CustomError");
const asyncErrorWrapper = require("express-async-handler");

const getAllProduct = asyncErrorWrapper(async (req, res, next) => {
  const product = await Product.find();

  console.log(product);
  return res.status(200).json({
    success: true,
    data: product,
  });
});

const getWarehouseProduct = asyncErrorWrapper(async (req, res, next) => {
  const { warehouseId } = req.params;

  const warehouse = await Warehouse.findById(warehouseId).populate("products");

  console.log(warehouse);
  return res.status(200).json({
    success: true,
    data: warehouse.products,
  });
});

const addWarehouseProduct = asyncErrorWrapper(async (req, res, next) => {
  // const {id} = req.params;
  const products = req.body;
  const warehouse = req.data;
  const warehouseId =warehouse._id || warehouse
  if (Object.keys(req.body).length === 0) {
    return next(new CustomError("There is no warehouse info", 400));
  }

  for(const data of products){
    console.log(data)
    var getProduct = await Product.findOne({ name: data.name, warehouse: warehouseId });
    console.log(getProduct)
    if (getProduct) {
      getProduct.stock += data.amount;
      await getProduct.save();
      console.log("ürün halihazırda var")
      console.log(getProduct)
    } else {
      console.log("ürün ilk defa ekleniyor")
  
      data.stock=data.amount;
      const product = await Product.create({
          ...data,
      });
      
      
      console.log("4")
 
      product.warehouse = warehouseId;
      await product.save();

      warehouse.products.push(product.populate("warehouse"));
      await warehouse.save();
      getProduct = product;
    }
  }
  

  console.log("finis")

  return res.status(200).json({
    success: true,
    data: products
  });
});
const transferProduct = asyncErrorWrapper(async (req, res, next) => {
    const { products } = req.body;
    const { to } = req.params;
  
    const warehouseTo = await Warehouse.findById(to);
    const warehouse = req.from;
  
    return res.status(200).json({
      success: true,
      message: "Request has been taken successfully",
    });
  });
module.exports = {
  getAllProduct,
  getWarehouseProduct,
  addWarehouseProduct,
  transferProduct
};
