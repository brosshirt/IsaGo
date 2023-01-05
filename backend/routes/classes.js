const express = require('express');
const router = express.Router();
const fs = require('fs');

router.get('/', (req, res) => {
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

router.get('/:class_name', (req, res) => {
    console.log("/:class_name is being touched by " + req.session.student_id);
    db.query(`
        select lesson_name, lesson_date from lesson where class_name = '${req.params.class_name}' order by lesson_date desc`)
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
        })
})

router.get('/:class_name/:lesson_name', (req, res) => {
    console.log("/:class_name/:lesson_name is being touched by " + req.session.student_id);
    
    const fileBuffer = fs.readFileSync(`/app/lessons/${req.params.class_name}/${req.params.lesson_name}.pdf`);
    const pdfBase64 = fileBuffer.toString('base64');

    res.send({
        status: 200,
        lesson: pdfBase64
    })

})


router.post('/', (req,res) => {
    console.log(req.session.student_id + " is trying to add the class " + req.body.name)


    db.query(`
        insert into takes values ('${req.session.student_id}','${req.body.name}')
    `)
    res.send({
        status: 200
    })
})

router.delete('/', (req,res) => {
    console.log(req.session.student_id + " is trying to delete the class " + req.body.name)
    
    db.query(`
        delete from takes where student_id = '${req.session.student_id}' and class_name = '${req.body.name}'
    `)
    
    res.send({
        status: 200
    })
})

module.exports = router;


