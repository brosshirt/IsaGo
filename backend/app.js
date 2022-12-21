const express = require('express')
const app = express()
const session = require('express-session')

require('dotenv').config()

const {Client} = require('pg')

const db = new Client({
    host: "postgres",
    user: "postgres",
    port: 5432,
    password: "postgres",
    database: "postgres"
})

db.connect()

db.query('create table if not exists testtable(testfield varchar, testfield2 varchar)')


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
 

// app.get('/', (req, res) => {
//     db.query(`select ${req.body.field} from testtable`).then(data => { // you're going to want to create your own wrapper functions for this shit, you want interacting with the DB to be smoother
//         res.send((data.rows))
//     }).catch(err => {
//         console.log(err)
//     }) 
    
//     db.query(`insert into testtable values('bloom', 'bloop')`)
// })

app.get('/classes', (req, res) => {
    res.send({
        status: 200,
        taking: [
            {name: "Science"},
            {name: "Phys Ed"},
            {name: "Recess"},
            {name: "Skip"},
            {name: "CSE 340 - Advanced Algorithmic Analysis"},
            {name: "Ballin"}
        ],
        notTaking: ["Lebron Studies", "Boomin", "Cunnilingus"]
    })
})

app.post('/login', (req, res) => {
    res.send({
        status: 200,
        msg: "hello " + req.body.name
    })
})

app.post('/class', (req,res) => {
    res.send({
        status: 200,
        msg: "You've made a post request to add " + req.body.name + " to your class list"
    })
})

app.delete('/class', (req,res) => {
    res.send({
        status: 200,
        msg: "You've made a delete request to delete " + req.body.name + " from your class list"
    })
})





app.listen(3000, '0.0.0.0', () => console.log('the app is uppppppppp ✔️'));