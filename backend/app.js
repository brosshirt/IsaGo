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

function buildDB(){
    buildClassTable()
    buildStudentTable()
    buildTakesTable()
}

function buildClassTable(){
    db.query('create table if not exists class(class_name varchar primary key)')
}
function buildStudentTable(){
    db.query('create table if not exists student(student_id varchar primary key)')
}
function buildTakesTable(){
    db.query(`create table if not exists takes(
        student_id varchar references student(student_id) on delete cascade,
        class_name varchar references class(class_name) on delete cascade,
        PRIMARY KEY (student_id, class_name))`)
}

function populateDB(){
    db.query(`
        INSERT INTO class(class_name)
        VALUES ('Mech 83')
        ON CONFLICT (class_name) DO NOTHING;`)
    db.query(`
        INSERT INTO class(class_name)
        VALUES ('CS 22')
        ON CONFLICT (class_name) DO NOTHING;`)
    db.query(`
        INSERT INTO class(class_name)
        VALUES ('ENG 23')
        ON CONFLICT (class_name) DO NOTHING;`)
    db.query(`
        INSERT INTO class(class_name)
        VALUES ('MATH 92')
        ON CONFLICT (class_name) DO NOTHING;`)
    db.query(`
        INSERT INTO class(class_name)
        VALUES ('SEX 109')
        ON CONFLICT (class_name) DO NOTHING;`)
}


buildDB()
populateDB()




app.get('/classes', (req, res) => {
    console.log(req.session.student_id)
    
    db.query(`select class_name from class where class_name in (
        select class_name from takes where student_id = '${req.session.student_id}')`)
        .then(data => { 
            res.send({
                status: 200,
                classes: data.rows 
            })
    }).catch(err => {
        console.log(err)
    }) 
})

app.get('/available', (req, res) => {
    console.log(req.session.student_id)
    
    db.query(`select class_name from class where class_name not in (
        select class_name from takes where student_id = '${req.session.student_id}')`)
        .then(data => { 
            res.send({
                status: 200,
                classes: data.rows 
            })
    }).catch(err => {
        console.log(err)
    }) 
})




app.post('/login', (req, res) => {
    
    db.query(`
        INSERT INTO student(student_id)
        VALUES ('${req.body.name}')
        ON CONFLICT (student_id) DO NOTHING;`)

    req.session.student_id = req.body.name
    
    res.send({
        status: 200,
        msg: "hello " + req.body.name
    })
})

app.post('/class', (req,res) => {
    
    db.query(`
        insert into takes values ('${req.session.student_id}','${req.body.name}')
    `)
    res.send({
        status: 200
    })
})

app.delete('/class', (req,res) => {
    db.query(`
        delete from takes where student_id = '${req.session.student_id}' and class_name = '${req.body.name}'
    `)
    
    res.send({
        status: 200
    })
})





app.listen(3000, '0.0.0.0', () => console.log('the app is uppppppppp ✔️'));