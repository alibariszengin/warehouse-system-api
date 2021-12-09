const mongoose = require("mongoose");
const  Schema  = mongoose.Schema;

const ProductSchema = new Schema({
    
    name: {
        type: String,
        required : [true, "Please provide a name"]
    },
    brand:{
        type: String,
    },
    barcode:{
        type: String,
    
    },
    stock:{
        type: Number,
        required : [true, "Please provide a stock info"]
    },
    reserved:{
        type:Number,
        default:0
    },
    warehouse:{
            
        type: Schema.Types.ObjectId,
        ref: "Warehouse"
        
    },
    createdAt : {
        type : Date, 
        default : Date.now
    },
    title: {
        type: String
    },
    about : {
        type: String
    }
    
});

module.exports = mongoose.model("Product",ProductSchema);