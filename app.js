const express = require('express')
const app = express()
const session = require('express-session')

require('dotenv').config()

const {Client} = require('pg')

const db = new Client({
    host: "raja.db.elephantsql.com",
    user: "zjzxclhd",
    port: 5432,
    password: process.env.DB_PW,
    database: "zjzxclhd"
})

db.connect()


app.use(require('body-parser').urlencoded({ // this is needed so that req.body isn't undefined
    extended:true
}));
app.use(express.json()); // this is needed for req.body to receive json

app.use(session({
  secret: 'lebron',
  resave: true,
  saveUninitialized: false,
  rolling: true,
  cookie: {
     expires: 1000000
  }
}));
 

app.get('/', (req, res) => {
    db.query(`select ${req.body.field} from testTable`).then(data => { // you're going to want to create your own wrapper functions for this shit, you want interacting with the DB to be smoother
        res.send((data.rows))
    }).catch(err => {
        console.log(err)
    })  
})


app.listen(3000, 'localhost');