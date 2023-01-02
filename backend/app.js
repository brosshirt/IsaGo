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
 
// what routes do we need, we'll probably want to rename our shit
// /classes gets all the classes a student takes
// /:class_name gets a particular classes lesson
// post /class adds a class to the class list
// delete /class deletes a class from the class list

// ok lets make 1 route called /classes and rename some of these routes
// get /classes is the same of course
// get /classes/:class_name
// post /classes
// delete /classes



// login can be its own route I guess

// later on I'll have 
// /lesson will get you the lesson pdf
// post /lesson/feedback will allow you to post feedback for the less


const classesRouter = require("./routes/classes.js");
app.use('/classes', classesRouter);

const loginRouter = require("./routes/login.js");
app.use('/login', loginRouter);





app.listen(3000, '0.0.0.0', () => console.log('the app is uppppppppp ✔️'));