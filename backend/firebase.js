var admin = require("firebase-admin");
var serviceAccount = require('./serviceAccount.js').getServiceAccount()

const timestring = require('./timestring.js');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const fcm = admin.messaging()
const firestore = admin.firestore()

// this either creates a new user account and adds the token or simply adds the token if its new
function updateUser(studentId, token){
    
    const usersCollection = firestore.collection('users')

    usersCollection.where('studentId', '==', studentId).get()
    .then(snapshot => {
        if (snapshot.empty) {
            const newUser = { 
                studentId: studentId,
                tokens: [token]
            }
            usersCollection.add(newUser)
            .catch(error => {
                console.error('Error adding new user: ', error);
            });
            return;
        }

        const user = snapshot.docs[0];

        
        if (!user.data().tokens.includes(token)){
            user.ref.update({
                tokens: admin.firestore.FieldValue.arrayUnion(token)
            })
            .catch(error => {
                console.error('Error adding token to DB: ', error);
            });
        }
    })
    .catch(error => {
        console.error('Error checking for user: ', error);
    });
}

function deleteUser(studentId){
    const usersCollection = firestore.collection('users');

    removeAllNotifs(studentId)

    usersCollection.where('studentId', '==', studentId).get()
    .then(snapshot => {
        snapshot.forEach(doc => {
            doc.ref.delete();
        });
    })
    .catch(error => {
        console.error('Error deleting user: ', error);
    });
}

function addNotif(studentId, className, classTime){
    let notificationSchedule = timestring.addToTimeString(classTime, -15)

    content = {
        title: `Todays's ${className} ISAGO Summary`,
        body: 'Take 60 seconds to get ahead of class! 📚',
        sound: 'default'
    }

    const notificationsCollection = firestore.collection('notifications');

    notificationsCollection.add({
        studentId,
        className,
        classTime,
        notificationSchedule,
        content
    })
    .then(ref => {
        console.log(`Notification added with ID: ${ref.id}`)
    })
    .catch(error => {
        console.error(`Error adding notification: ${error}`);
    });
}
// removes a particular notification
function removeNotif(studentId, className, classTime){
    const notificationsCollection = firestore.collection('notifications');


    notificationsCollection.where('studentId', '==', studentId)
        .where('className', '==', className)
        .where('classTime', '==', classTime)
        .get()
        .then(snapshot => {
            snapshot.forEach(doc => {
                doc.ref.delete();
            });
        })
        .catch(error => {
            console.error("Error deleting notification: ", error);
        });
}
// removes all the notifications for a particular user
function removeAllNotifs(studentId){
    const notificationsCollection = firestore.collection('notifications');

    notificationsCollection.where('studentId', '==', studentId).get()
    .then(snapshot => {
        snapshot.forEach(doc => {
            doc.ref.delete();
        });
    })
    .catch(error => {
        console.error('Error deleting user: ', error);
    });
}




module.exports = {
    updateUser: updateUser,
    deleteUser: deleteUser,
    addNotif: addNotif,
    removeNotif: removeNotif,
    removeAllNotifs: removeAllNotifs
}

