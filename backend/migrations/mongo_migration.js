const fs = require("fs")
const {Product} = require("../models/products")
const mongoose = require("mongoose")

mongoose.connect("mongodb://localhost:27017/foodapp", {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => {
  console.log("MongoDB connected");
})
.catch((err) => {
  console.error("MongoDB connection error:", err);
});

function fileRead() {
    try {
        const data = fs.readFileSync("./api/fruitsAndVegs.json", { encoding: "utf-8" });
        return JSON.parse(data);
    } catch (err) {
        console.error(err);
        return null;
    }
}

const products = fileRead()

async function saveProduct(product){
    let newProduct = new Product(product)
    try{
        let savedProduct = await newProduct.save()
        console.log(savedProduct)
    }catch(err){
        console.log(err)
    }
}

for (var i=0;i<products.length;i++){
    saveProduct(products[i])
}