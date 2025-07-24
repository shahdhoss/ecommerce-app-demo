module.exports = (sequelize, DataTypes)=>{
    const users = sequelize.define("users", {
        id:{
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        name:{
            type: DataTypes.STRING,
            allowNull: false
        }, 
        email:{
            type: DataTypes.STRING,
            allowNull: false
        },
        refresh_token:{
            type: DataTypes.STRING,
        }
    })
    return users
}