const {Client} = require('pg')


function buildDB(db){
    buildClassTable(db)
    buildStudentTable(db)
    buildTakesTable(db)
    buildLessonTable(db)
    buildFeedbackTable(db)
}

function buildClassTable(db){
    db.query('create table if not exists class(class_name varchar primary key)')
}
function buildStudentTable(db){
    db.query('create table if not exists student(student_id varchar primary key)')
}
function buildTakesTable(db){
    db.query(`create table if not exists takes(
        student_id varchar references student(student_id) on delete cascade,
        class_name varchar references class(class_name) on delete cascade,
        PRIMARY KEY (student_id, class_name))`)
}
function buildLessonTable(db){
    db.query(`create table if not exists lesson(
        class_name varchar references class(class_name),
        lesson_name varchar,
        lesson_date timestamp,
        PRIMARY KEY (class_name, lesson_name))`)
}

function buildFeedbackTable(db){
    db.query(`create table if not exists feedback (
        class_name varchar references class(class_name),
        lesson_name varchar,
        feedback varchar primary key,
        feedback_date timestamp default current_timestamp,
        student_id varchar references student(student_id),
          FOREIGN KEY (class_name, lesson_name) REFERENCES lesson (class_name, lesson_name)
    )
    `)
}


function populateClasses(db){
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

function populateLessons(db){
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

function populateDB(db){
    populateClasses(db)
    populateLessons(db)
}

function getDB(){
    const db = new Client({
        host: "postgres",
        user: "postgres",
        port: 5432,
        password: "postgres",
        database: "postgres"
    })

    db.connect()

    buildDB(db)
    populateDB(db)

    return db
}

module.exports = {getDB: getDB}
