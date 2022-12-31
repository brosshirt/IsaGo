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
    buildLessonTable()
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
function buildLessonTable(){
    db.query(`create table if not exists lesson(
        class_name varchar references class(class_name),
        lesson_name varchar,
        lesson_date timestamp,
        PRIMARY KEY (class_name, lesson_name))`)
}


function populateClasses(){
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

function populateLessons(){
    // So for each class we want to add 3 lessons, I want the dates to be dec 28, 29, 30
    db.query(`
        insert into lesson (class_name, lesson_name, lesson_date) values ('SEX 109', 'I miss her so much', '2022-12-30') ON CONFLICT (class_name, lesson_name) DO NOTHING;
        insert into lesson (class_name, lesson_name, lesson_date) values ('SEX 109', 'Filling the void', '2022-12-29') ON CONFLICT (class_name, lesson_name) DO NOTHING;
        insert into lesson (class_name, lesson_name, lesson_date) values ('SEX 109', 'Eating box', '2022-12-28') ON CONFLICT (class_name, lesson_name) DO NOTHING;
        
        insert into lesson (class_name, lesson_name, lesson_date) values ('MATH 92', 'Switching Majors', '2022-12-30') ON CONFLICT (class_name, lesson_name) DO NOTHING;
        insert into lesson (class_name, lesson_name, lesson_date) values ('MATH 92', 'Using ChatGPT', '2022-12-29') ON CONFLICT (class_name, lesson_name) DO NOTHING;
        insert into lesson (class_name, lesson_name, lesson_date) values ('MATH 92', 'Using Calculators', '2022-12-28') ON CONFLICT (class_name, lesson_name) DO NOTHING; 
        
        insert into lesson (class_name, lesson_name, lesson_date) values ('ENG 23', 'Knife Talk', '2022-12-30') ON CONFLICT (class_name, lesson_name) DO NOTHING;
        insert into lesson (class_name, lesson_name, lesson_date) values ('ENG 23', 'Building Relationships', '2022-12-29') ON CONFLICT (class_name, lesson_name) DO NOTHING;
        insert into lesson (class_name, lesson_name, lesson_date) values ('ENG 23', 'Building Houses', '2022-12-28') ON CONFLICT (class_name, lesson_name) DO NOTHING;
        
        insert into lesson (class_name, lesson_name, lesson_date) values ('CS 22', 'Beep Boop', '2022-12-30') ON CONFLICT (class_name, lesson_name) DO NOTHING;
        insert into lesson (class_name, lesson_name, lesson_date) values ('CS 22', 'Starcraft', '2022-12-29') ON CONFLICT (class_name, lesson_name) DO NOTHING;
        insert into lesson (class_name, lesson_name, lesson_date) values ('CS 22', 'Typing', '2022-12-28') ON CONFLICT (class_name, lesson_name) DO NOTHING;
        
        insert into lesson (class_name, lesson_name, lesson_date) values ('Mech 83', 'Torque', '2022-12-30') ON CONFLICT (class_name, lesson_name) DO NOTHING;
        insert into lesson (class_name, lesson_name, lesson_date) values ('Mech 83', 'Gravity', '2022-12-29') ON CONFLICT (class_name, lesson_name) DO NOTHING;
        insert into lesson (class_name, lesson_name, lesson_date) values ('Mech 83', 'Bodies and Spaces', '2022-12-28') ON CONFLICT (class_name, lesson_name) DO NOTHING;
        
    `)


}



function populateDB(){
    populateClasses()
    populateLessons()
}


buildDB()
populateDB()




app.get('/classes', (req, res) => {
    console.log("/classes is being touched by " + req.session.student_id);
    db.query(` 
        WITH taking AS (
            select class_name from class where class_name in (
                select class_name from takes where student_id = '${req.session.student_id}')
        )
        SELECT t.class_name,
                CASE WHEN t.class_name IN (SELECT class_name FROM taking) THEN true ELSE false END AS isTaking
        FROM class AS t`).then(data => {
            let taking = []
            let notTaking = []
            for (row of data.rows){
                if (row.istaking){
                    taking.push({class_name: row.class_name})
                }
                else{
                    notTaking.push({class_name: row.class_name})
                }
            }
            res.send({
                status: 200,
                taking: taking, 
                notTaking: notTaking
            })
        }).catch(err => {
            console.log(err)
        })
})

app.get('/:class_name', (req, res) => {
    console.log("/:class_name is being touched by " + req.session.student_id);
    db.query(`
        select lesson_name, lesson_date from lesson where class_name = '${req.params.class_name}' order by lesson_date desc`)
        .then(data => {
            console.log(data.rows)
            res.send({
                status: 200,
                lessons: data.rows
            })
        }).catch(err => {
            console.log(err)
        })


})




app.post('/login', (req, res) => {
    console.log("/login is being touched by " + req.session.student_id);
    console.log("req.body.name is " + req.body.name)


    db.query(`
        INSERT INTO student(student_id)
        VALUES ('${req.body.name}')
        ON CONFLICT (student_id) DO NOTHING;`)

    req.session.student_id = req.body.name
    
    res.send({
        status: 200
    })
})

app.post('/class', (req,res) => {
    console.log(req.session.student_id + " is trying to add the class " + req.body.name)


    db.query(`
        insert into takes values ('${req.session.student_id}','${req.body.name}')
    `)
    res.send({
        status: 200
    })
})

app.delete('/class', (req,res) => {
    console.log(req.session.student_id + " is trying to delete the class " + req.body.name)
    
    db.query(`
        delete from takes where student_id = '${req.session.student_id}' and class_name = '${req.body.name}'
    `)
    
    res.send({
        status: 200
    })
})





app.listen(3000, '0.0.0.0', () => console.log('the app is uppppppppp ✔️'));