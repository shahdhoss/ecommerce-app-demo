const fs = require("fs")
const {products} = require("../models")

insertItems = async (data)=> {
    for (var i=0;i<data.length ;i++){
        if(data[i].product_title && data[i].product_price && data[i].product_photo && data[i].product_star_rating && data[i].product_num_ratings){
            await products.create({title: data[i].product_title, price: data[i].product_price, picture: data[i].product_photo, rating: data[i].product_star_rating,  num_ratings: data[i].product_num_ratings, sales_volume: data[i].sales_volume || null,unit_count: Math.floor(Math.random() * 10) + 1 })
            console.log(data[i].product_title && data[i].product_price && data[i].product_photo && data[i].product_star_rating && data[i].product_num_ratings)
        }
    }
}
try{
    const list = [281407, 281410, 281510]
    for (var i=0;i<list.length;i++){
        const data = JSON.parse(fs.readFileSync(`./api/${list[i]}.json`, "utf-8"))
        console.log(data[0])
        insertItems(data)
    }
}catch(err){
    console.log(err)
}