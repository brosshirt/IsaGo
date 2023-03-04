const functions = require('firebase-functions');
const admin = require('firebase-admin');
const {PubSub} = require('@google-cloud/pubsub');
const {CloudSchedulerClient} = require('@google-cloud/scheduler').v1;
const schedulerClient = new CloudSchedulerClient();

require('dotenv').config();


const projectId = process.env.GOOGLE_PROJECT_ID

var serviceAccount = {
    "type": "service_account",
    "project_id": projectId,
    "private_key_id": process.env.GOOGLE_PRIVATE_KEY_ID,
    "private_key": process.env.GOOGLE_PRIVATE_KEY,
    "client_email": process.env.GOOGLE_CLIENT_EMAIL,
    "client_id": process.env.GOOGLE_CLIENT_ID,
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": process.env.GOOGLE_CLIENT_X509_CERT_URL
}


admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const firestore = admin.firestore()
const fcm = admin.messaging()



let iters = 1

const pubsub = new PubSub({projectId});

// this is the code that we want to run once and only once, create the topic and sub with the appropriate trigger


async function getOrCreateTopic(topicName) {
    let topic;
    try {
      [topic] = await pubsub.topic(topicName).get();
    } catch (err) {
      if (err.code === 5) { // topic does not exist
        topic = await pubsub.createTopic(topicName);;
      } else {
        throw err;
      }
    }
    return topic;
  }

function toCronSyntax(schedule) {
    const [days, time] = schedule.split('-');
    const hour = time.substring(0, 2)
    const minute = time.substring(2, 4)

    const daysMap = {
        'M': '1',
        'T': '2',
        'W': '3',
        'H': '4',
        'F': '5',
        'S': '6',
        'U': '7'
    };

    const cronDays = [...days].map(day => daysMap[day]).join(',');

    return `${minute} ${hour} * * ${cronDays}`;
}

function getJobName(parent, notification){
    return `${parent}/jobs/${notification.studentId.replace('@', '__at__').replace('.', '__dot__')}--${notification.className.replace(' ', '_')}--${notification.classTime}`
}


exports.deleteSchedule = functions.firestore
  .document('notifications/{notificationsId}')
  .onDelete(async snapshot => {
    const oldNotification = snapshot.data();

    const parent = `projects/${projectId}/locations/us-central1`
  
    const jobName = getJobName(parent, oldNotification)

    await schedulerClient.deleteJob({
        name: jobName
    });

  })


exports.schedulePubSub = functions.firestore
    .document('notifications/{notificationsId}')
    .onCreate(async snapshot => {

        await getOrCreateTopic('classNotifs')

        const newNotification = snapshot.data();
        
        const parent = `projects/${projectId}/locations/us-central1`

        const jobName = getJobName(parent, newNotification)

        const job = {
            name: jobName,
            pubsubTarget: {
              topicName: `projects/${projectId}/topics/classNotifs`,
              data: Buffer.from(JSON.stringify(newNotification)).toString('base64')
            },
            schedule: "* * * * *",
            // schedule: toCronSyntax(newNotification.notificationSchedule),
            timeZone: 'America/New_York'
        };

        const request = {
            parent,
            job
        }

        await schedulerClient.createJob(request)
        // const data = Buffer.from(JSON.stringify(newNotification));
        // topic.publishMessage({data});
})

exports.sendNotif = functions.pubsub
    .topic('classNotifs')
    .onPublish(async message => {
        console.log(`iteration ` + iters++)
        
        const data = Buffer.from(message.data, 'base64').toString()

        const notification = JSON.parse(data);

        const usersCollection = firestore.collection('users');
    
        const payload = {
            notification: notification.content
        }

        usersCollection.where('studentId', '==', notification.studentId).get()
        .then(snapshot => {
            const user = snapshot.docs[0];
            const tokens = user.data().tokens;
            console.log(tokens)
            fcm.sendToDevice(tokens, payload)
        })
        .catch(error => {
            console.error('Error deleting user: ', error);
        });
    })





