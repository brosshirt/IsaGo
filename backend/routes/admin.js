const express = require('express');
const router = express.Router();
const crypto = require("crypto-js");
const multer = require('multer');
const s3 = require('../s3.js').s3;


router.get('/', (req,res) => {
    res.render('admin')
})


router.post('/lesson', multer().single('lessonfile'), (req,res) => {
    let classtimes = []

    if (req.body.classname == 'MECH 003'){
        classtimes = ['MWF-1045', 'MWF-1335']
    }
    else{
        classtimes = ['MWF-1045', 'MWF-1210']
    }
    
    
    let pw = crypto.SHA256(req.body.password).toString()

    const query = `select * from admin where username = $1` // search the db for the user
    const values = [req.body.username]

    db.query(query, values).then(data => {
        if (data.rows.length === 0){ // no user found
            return res.send({
                status: 401,
                msg: "There are no admin users with that username"
            })
        }
        // I'm going to ignore the weird situation where there are multiple admin users with the same username
        if (data.rows[0].hash !== pw){ // pw doesn't match
            return res.send({
                status: 401,
                msg: "Incorrect password"
            })
        }
        else{ // authenticated
            
            const params = {
                Bucket: 'isago-lessons',
                Key: `${req.body.classname}/${req.body.lessonname}.pdf`, // name of file in s3
                Body: req.file.buffer,
                ContentType: 'application/pdf',
                ACL: 'public-read'
            };

            s3.putObject(params, (err, data) => {
                if (err) {
                    console.log('ERROR')
                    console.log(err);
                    return res.send({
                        status: 500,
                        msg: 'There was an issue uploading your file to s3'
                    })
                }
                console.log(`File uploaded successfully. ${data.Location}`);
                // update the DB
                
                const query = `insert into lesson values($1, $2, $3)` // search the db for the user
                const values = [req.body.classname, req.body.lessonname, req.body.lessondate]

                db.query(query, values).then(data => { // add the first lecture
                    const query = `insert into lecture values($1, $2, $3, $4);` 
                    const values = [req.body.classname, classtimes[0], req.body.lessonname, req.body.lessondate]
                    db.query(query, values).then(data => { // on success, add the second lecture
                        const query = `insert into lecture values($1, $2, $3, $4);` 
                        const values = [req.body.classname, classtimes[1], req.body.lessonname, req.body.lessondate]
                        db.query(query, values).then(data => {
                            return res.send({
                                status: 200,
                                msg: "Lesson is added, all good!"
                            })
                        }).catch(err => {
                            console.log(err)
                            return res.send({
                                status: 500,
                                msg: "An error occured while adding the lecture information for the section at " + classtimes[1]
                            })
                        })
                    }).catch(err => {
                        console.log(err)
                        return res.send({
                            status: 500,
                            msg: "An error occured while adding the lecture information for the section at " + classtimes[0]
                        })
                    })
                }).catch(err => {
                    console.log(err)
                    return res.send({
                        status: 500,
                        msg: "An error has occured while adding the lesson information"
                    })
                })
            });

            
        }

        
        
        
        
        
    }).catch(err => {
        console.log(err)
        res.send({
            status: 400,
            msg: "An error has occured with the admin operation"
        })
    })


})




module.exports = router;


