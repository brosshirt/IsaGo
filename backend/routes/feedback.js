const express = require('express');
const router = express.Router();

router.post('/', (req, res) => {
    console.log("/feedback is being touched by " + req.session.student_id);
    
    // what does the body look like

    // class_name, might be undefined, if it's undefined then we want to write default instead
    if (!req.body.feedback){
        res.send({
            status:400,
            msg: "Feedback field must be defined"
        })
        return
    }

    let sanitizedReqBody = {
        class_name: req.body.class_name != "None" ? req.body.class_name : undefined,
        lesson_name: req.body.lesson_name != "None" ? req.body.lesson_name : undefined,
        feedback: req.body.feedback,
    }

    console.log(sanitizedReqBody)


    const query = `insert into feedback values ($1, $2, $3, default, $4)`

    // const values = [sanitizedReqBody.class_name, sanitizedReqBody.lesson_name, sanitizedReqBody.feedback, req.session.student_id]
    const values = [sanitizedReqBody.class_name, sanitizedReqBody.lesson_name, sanitizedReqBody.feedback, req.session.student_id]

    db.query(query, values).then(data => {
        res.send({
            status: 200,
        })
    }).catch(err => {
        console.log(err)
        res.send({
            status:400,
            msg: "Somebody has already sent that exact feedback"
        })
    })
    
    

    
})


module.exports = router;