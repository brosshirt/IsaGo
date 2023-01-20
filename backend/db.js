const {Client} = require('pg')


function buildDB(db){
    buildClassTable(db)
    buildStudentTable(db)
    buildSectionTable(db)
    buildTakesTable(db)
    buildLessonTable(db)
    buildLectureTable(db)
    buildFeedbackTable(db)
}

function buildClassTable(db){
    db.query('create table if not exists class(class_name varchar primary key)')
}
function buildStudentTable(db){
    db.query('create table if not exists student(student_id varchar primary key)')
}
function buildSectionTable(db){
    db.query(`
        create table if not exists section(
            class_name varchar references class(class_name) on delete cascade,
            sec_id int,
            class_time varchar,
            crn int,
            PRIMARY KEY(class_name, class_time)
        )`)
}
function buildTakesTable(db){
    db.query(`create table if not exists takes(
        student_id varchar references student(student_id) on delete cascade,
        class_name varchar references class(class_name) on delete cascade,
        class_time varchar,
        FOREIGN KEY (class_name, class_time) REFERENCES section(class_name, class_time) on delete cascade,
        PRIMARY KEY (student_id, class_name, class_time))`)
}
function buildLessonTable(db){
    db.query(`create table if not exists lesson(
        class_name varchar references class(class_name) on delete cascade,
        lesson_name varchar,
        lesson_date timestamp default current_timestamp,
        PRIMARY KEY (class_name, lesson_name))`)
}
function buildLectureTable(db){
    db.query(`
        create table if not exists lecture(
            class_name varchar references class(class_name) on delete cascade,
            class_time varchar,
            lesson_name varchar,
            lecture_date timestamp default current_timestamp,
            foreign key (class_name, lesson_name) references lesson(class_name, lesson_name) on delete cascade,
            foreign key (class_name, class_time) references section(class_name, class_time) on delete cascade,
            primary key (class_name, class_time, lesson_name, lecture_date)	
        )`)
}
function buildFeedbackTable(db){
    db.query(`create table if not exists feedback (
        class_name varchar references class(class_name) on delete cascade,
        lesson_name varchar,
        feedback varchar primary key,
        feedback_date timestamp default current_timestamp,
        student_id varchar references student(student_id) on delete cascade,
        FOREIGN KEY (class_name, lesson_name) REFERENCES lesson (class_name, lesson_name) on delete cascade
    )
    `)
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
    return db
}

module.exports = {getDB: getDB}
