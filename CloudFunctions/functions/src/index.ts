import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore
  .document('notification/{notificationId}')
  .onCreate(async snapshot => {


    const notification = snapshot.data();

    const querySnapshot = await db
       .collection('users')
       .doc(notification.receiver)
       .collection('tokens')
       .get();

     const tokens = querySnapshot.docs.map(snap => snap.id);
  
    //var tokens = ['c3tlmM7fSdq97Cw12e2qLS:APA91bEJHdYII8FahAdLE3ugnnPlrW7HClGjVGPuZsoj5bn4Tbsvs0pEMRpngB//cnF5HFQM1JQnJHk1TlwRXrgXGXzmX09r49lNg4IQPzqZAQv_7l5OMVNX8nGnMxEvYMum7wn0hhkuD0'];

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Comment!',
        body: notification.body,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    return fcm.sendToDevice(tokens, payload);
  });


// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
