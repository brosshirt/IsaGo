const express = require('express');
const router = express.Router();
const sgMail = require('@sendgrid/mail')
sgMail.setApiKey(process.env.SENDGRID_KEY)

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


    const query = `insert into feedback values ($1, $2, $3, default, $4)`

    // const values = [sanitizedReqBody.class_name, sanitizedReqBody.lesson_name, sanitizedReqBody.feedback, req.session.student_id]
    const values = [sanitizedReqBody.class_name, sanitizedReqBody.lesson_name, sanitizedReqBody.feedback, req.session.student_id]

    db.query(query, values).then(data => {
        sendFeedbackEmail(req.session.student_id, sanitizedReqBody.feedback, sanitizedReqBody.class_name, sanitizedReqBody.lesson_name)
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

function sendFeedbackEmail(studentID, feedback, className, lessonName){
    
    
    console.log(feedback)


    const msg = {
    to: 'brosshirt@gmail.com', 
    from: 'brosshirt@gmail.com', 
    subject: 'New Feedback!',
    text: 'This is irrelevant',
    html: `
            <html>
                <head>
                    <style>
                        body {
                            font-family: Arial, sans-serif;
                            font-size: 14px;
                            line-height: 1.5;
                        }
                        .container {
                            max-width: 600px;
                            margin: 0 auto;
                            padding: 20px;
                            background-color: #f7f7f7;
                            border: 1px solid #ddd;
                        }
                        h1 {
                            margin-top: 0;
                            margin-bottom: 20px;
                            font-size: 20px;
                            font-weight: bold;
                        }
                        p {
                            margin: 0 0 10px;
                        }
                        .feedback {
                            margin-top: 20px;
                            padding: 10px;
                            background-color: #fff;
                            border: 1px solid #ddd;
                        }
                    </style>
                </head>
                <body>
                    <div class="container">
                    <h1>Student ${studentID} added some feedback${className ? ' on class ' + className : ''}${lessonName ? ' and lesson ' + lessonName : ''}</h1>
                    <div class="feedback">
                        ${feedback.replace(/&/g, '&amp;')
                            .replace(/</g, '&lt;')
                            .replace(/>/g, '&gt;')
                            .replace(/"/g, '&quot;')
                            .replace(/'/g, '&#x27;')
                            .replace(/\\/g, '\\\\') // replace backslashes with double backslashes
                            .replace(/\t/g, '&#x09;')
                            .replace(/\n/g, '<br>')}
                    </div>
                    </div>
                </body>
            </html>
            `,
        }
        sgMail
        .send(msg)
        .then(() => {
            console.log('Email sent')
        })
        .catch((error) => {
            console.error(error)
        })
    }




module.exports = router;