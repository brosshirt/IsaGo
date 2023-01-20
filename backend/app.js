const express = require('express')
const app = express()
const session = require('express-session')
const dbLib = require('./db.js');

require('dotenv').config()

db = dbLib.getDB()


app.use(require('body-parser').urlencoded({ // this is needed so that req.body isn't undefined
    extended:true
}));
app.use(express.json()); // this is needed for req.body to receive json

app.use(session({
  secret: 'lebron',
  resave: true,
  saveUninitialized: false,
  rolling: true,
  cookie: {
     expires: 1000000
  }
}));


const classesRouter = require("./routes/classes.js");
app.use('/classes', classesRouter);

const accountRouter = require("./routes/account.js");
app.use('/account', accountRouter);

const feedbackRouter = require("./routes/feedback.js");
app.use('/feedback', feedbackRouter);





app.listen(3000, '0.0.0.0', () => console.log('the app is uppppppppp ✔️'));