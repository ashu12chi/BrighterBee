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

    var community = notification.community;
    community = community.concat(',');
    var postId = notification.postId;
    postId = postId.concat(',');
    var id = community.concat(postId.toString());
    var name = notification.creator;
    var id2 = id.concat(name.toString());

     const tokens = querySnapshot.docs.map(snap => snap.id);
  
    //var tokens = ['c3tlmM7fSdq97Cw12e2qLS:APA91bEJHdYII8FahAdLE3ugnnPlrW7HClGjVGPuZsoj5bn4Tbsvs0pEMRpngB//cnF5HFQM1JQnJHk1TlwRXrgXGXzmX09r49lNg4IQPzqZAQv_7l5OMVNX8nGnMxEvYMum7wn0hhkuD0'];

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: notification.title,
        body: notification.body,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      },
      data: {
      	sound: 'default',
      	status: 'Comment',
      	id: id2
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

// In the notification collection in firestore following keys to be added:
// 1. receiver : person who will recieve notification
// 2. title : title of notification
// 3. body : Body of notification
// 4. community : Community in which that post belong
// 5. postId : Post Id.
// 6. creator: creator of Post

// Last three are for PostUI constructor 
