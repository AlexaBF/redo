var mysql= require ('mysql');

const config = {
    host: process.env.HOST,
    user: process.env.USER,
    password: process.env.PASS,
    database: process.env.DB,
    port: 3306,
    multipleStatements: true //Allow run transactions as queries
};

const connection = mysql.createConnection(config);
connection.connect((err)=>{
    if(err){
        console.log("Database connection failed")
        return
    }
    console.log("Connected to database")
})

//Check for the status of the connection
module.exports.isAlive = () => {
    const pingError = connection.ping((err)=>
        err
    )
    return !(pingError || connection.state === 'disconnected');
}


module.exports.connection = connection