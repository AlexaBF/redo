var mysql= require ('mysql');

const config = {
    host: 'redo.c4c6b7damgb3.us-east-1.rds.amazonaws.com', //process.env.HOST,
    user: 'sa', //process.env.USER,
    password: 'redo_makma', //process.env.PASS,
    database: 'REDO_MAKMA', //process.env.DB,
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