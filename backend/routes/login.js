const express = require('express');
const router = express.Router();
const fs = require('fs');



router.post('/', (req, res) => {
    console.log("/login is being touched by " + req.session.student_id);
    console.log("req.body.name is " + req.body.name)

    const query = `INSERT INTO student(student_id)
    VALUES ($1)
    ON CONFLICT (student_id) DO NOTHING;`

    const values = [req.body.name]


    db.query(query, values).then(data => {
        res.send({
            status: 200
        })
    }).catch(err => {
        console.log(err)
        res.send({
            status: 400,
            msg: "login failed"
        })

    })

    req.session.student_id = req.body.name
    
    
})

module.exports = router;