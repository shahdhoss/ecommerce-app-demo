module.exports = (sequelize, DataTypes)=> {
    const products = sequelize.define("products", {
        id:{
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true,
        },
        title:{
            type: DataTypes.STRING,
            allowNull: false
        },
        price:{
            type: DataTypes.STRING,
            allowNull: false
        },
        picture:{
            type: DataTypes.STRING,
            allowNull: false
        },
        rating:{
            type: DataTypes.STRING,
            allowNull:false
        },
        num_ratings:{
            type: DataTypes.INTEGER,
            allowNull:false
        },
        sales_volume:{
            type: DataTypes.STRING,
            allowNull: true
        },
        unit_count:{
            type: DataTypes.INTEGER,
            allowNull: false
        }
    })
    return products
}