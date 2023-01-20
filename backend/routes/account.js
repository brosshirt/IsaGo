const express = require('express');
const router = express.Router();


// this is your login or create account
router.post('/', (req, res) => {
    console.log("post /account is being touched by " + req.session.student_id);
    console.log("req.body.name is " + req.body.name)

    const query = `INSERT INTO student(student_id)
    VALUES ($1)
    ON CONFLICT (student_id) DO NOTHING;` // Does this mean that it's literally impossible for this db operation to fail? That's a problem

    const values = [req.body.name]


    db.query(query, values).then(data => {
        req.session.student_id = req.body.name
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
})
// delete your account
router.delete('/', (req, res) => {
    console.log(req.session.student_id + " tryna delete his account and stuff")
    const query = `DELETE FROM student WHERE student_id = $1;`
  
      const values = [req.session.student_id]
      
      db.query(query, values).then(data => {
        req.session.student_id = undefined
        res.send({
            status: 200
        })
      }).catch(err => {
          console.log(err)
          res.send({
              status: 400,
              msg: "delete account failed"
          })
      }) 
  })



module.exports = router;