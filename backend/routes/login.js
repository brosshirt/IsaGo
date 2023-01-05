const express = require('express');
const router = express.Router();
const fs = require('fs');



router.post('/', (req, res) => {
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

module.exports = router;