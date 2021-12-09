const mongoose = require("mongoose");
const  Schema  = mongoose.Schema;

const RequestSchema = new Schema({
    
    type:{
        type: String,
        enum:["create","transport"]
    },
    status:{
        type: String,
        default:"waiting",
        enum:["refused","waiting","accepted"]
        
    },
    from:{
        user:{
            type: Schema.Types.ObjectId,
            ref: "User"
        },
        warehouse:{
            type: Schema.Types.ObjectId,
            ref: "Warehouse"
        }
        
    },
    to:{
        user:{
            type: Schema.Types.ObjectId,
            ref: "User"
        },
        warehouse:{
            type: Schema.Types.ObjectId,
            ref: "Warehouse"
        }
    },
    product: [{
    
        product:{
            type: Schema.Types.ObjectId,
            ref: "Product",
            required : [true,"Please provide a product"]
        
        },
        amount:{
            type: Number,
            required : [true,"Please provide amount"]
        }

    }],
    updatedAt : {
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

module.exports = mongoose.model("Request",RequestSchema);