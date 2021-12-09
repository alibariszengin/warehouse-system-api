const mongoose = require("mongoose");
const  Schema  = mongoose.Schema;

const WarehouseSchema = new Schema({
    
    name: {
        type: String,
        required : [true, "Please provide a name"]
    },
    user:{
            
        type: Schema.Types.ObjectId,
        ref: "User"
        
    },
    products:[{
            
        type: Schema.Types.ObjectId,
        ref: "Product"
        
    }],
    // password: {
    //     type : String,
    //     minlength: [6,"Please proive a password with min length 6"],
    //     required : [true,"Please provide a password"],
    //     select : false
    // },
    createdAt : {
        type : Date, 
        default : Date.now
    },
    title: {
        type: String
    },
    about : {
        type: String
    },
    address : {
        type : String 
    },
    website : {
        type : String
    }
});

module.exports = mongoose.model("Warehouse",WarehouseSchema);