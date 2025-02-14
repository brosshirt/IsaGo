const express = require('express');
const router = express.Router();
const firebase = require('../firebase.js');

router.get('/', (req, res) => {
    console.log("/classes is being touched by " + req.session.student_id);

    // this returns the sections and adds a column istaking based on whether the student is taking this class
    const query = `WITH taking AS (
        select class_name, class_time from section where (class_name, class_time) in (
            select class_name, class_time from takes where student_id = $1)
    )
    SELECT t.class_name, t.class_time,
            CASE WHEN (t.class_name, t.class_time) IN (SELECT class_name, class_time FROM taking) THEN true ELSE false END AS isTaking
    FROM section AS t`

    const values = [req.session.student_id]

    db.query(query, values).then(data => {
            let taking = []
            let notTaking = []
            for (row of data.rows){
                if (row.istaking){
                    taking.push({class_name: row.class_name, class_time: row.class_time})
                }
                else{
                    notTaking.push({class_name: row.class_name, class_time: row.class_time})
                }
            }
            res.send({
                status: 200,
                taking: taking, 
                notTaking: notTaking
            })
        }).catch(err => {
            console.log(err)
            res.send({
                status: 400,
                msg: "An error has occurred retrieving classes"
            })
        })
})

router.post('/', (req,res) => {
    console.log(req.session.student_id + " is trying to add the section " + req.body.class_name + " taught at " + req.body.class_time)

    const query = `insert into takes values ($1,$2,$3)`

    const values = [req.session.student_id, req.body.class_name, req.body.class_time]

    db.query(query, values).then(data => {
        firebase.addNotif(req.session.student_id, req.body.class_name, req.body.class_time)
        res.send({
            status: 200
        })
    }).catch(err => {
        console.log(err)
        res.send({
            status: 400,
            msg: "An error has occured adding a class"
        })
    })
})

router.delete('/', (req,res) => {
    console.log(req.session.student_id + " is trying to delete the section " + req.body.class_name + "taught at " + req.body.class_time)
    
    const query = `delete from takes where student_id = $1 and class_name = $2 and class_time = $3`

    const values = [req.session.student_id, req.body.class_name, req.body.class_time]


    db.query(query, values).then(data => {
        firebase.removeNotif(req.session.student_id, req.body.class_name, req.body.class_time)
        res.send({
            status: 200
        })
    }).catch(err => {
        console.log(err)
        res.send({
            status: 400,
            msg: "An error has occured removing a class"
        })
    })
})

router.get('/:class_name', (req, res) => {
    console.log("/:class_name is being touched by " + req.session.student_id);
    
    const query = `select * from lesson where class_name = $1 order by lesson_date desc`
    
    const values = [req.params.class_name]
    
    db.query(query, values)
        .then(data => {
            for (row of data.rows){
                row.class_name = req.params.class_name
            }
            res.send({
                status: 200,
                lessons: data.rows
            })
        }).catch(err => {
            console.log(err)
            res.send({
                status: 400,
                msg: "An error has occurred retrieving " + req.params.class_name
            })
        })
})

// gets the lectures for a particular section
router.get('/:class_name/:class_time', (req, res) => {
    console.log("/:class_name/:class_time is being touched by " + req.session.student_id);
    
    const query = `select lesson_name, lecture_date from lecture where class_name = $1 and class_time = $2 order by lecture_date desc`
    
    const values = [req.params.class_name, req.params.class_time]
    
    db.query(query, values)
        .then(data => {
            for (row of data.rows){
                row.class_name = req.params.class_name
            }
            res.send({
                status: 200,
                lectures: data.rows
            })
        }).catch(err => {
            console.log(err)
            res.send({
                status: 400,
                msg: "An error has retrieving " + req.params.class_name
            })
        })
})





module.exports = router;


