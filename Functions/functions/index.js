const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

exports.notifyNewMessage = functions.firestore
    .document("messages/{messageID}")
    .onCreate(async (snapshot, context) => {
      const message = snapshot.data();
      functions.logger.log(message.text);

      const payload = {
        notification: {
          title: message.groupUid,
          body: message.displayName + ": " + message.text,
        },
      };
      let groupID = "Before";

      const docID = context.params.messageID;

      await db.collection("messages").doc(docID).get()
          .then((value) => {
            groupID = value.data()["groupUid"];
          });

      await db.collection("users").where("groups", "in", [groupID])
          .get().then((value) => {
            value.docs.forEach((doc) => {
              fcm.sendToDevice(doc.data()["deviceId"], payload);
              functions.logger.log(doc.data()["deviceId"]);
            });
          });

      return;
    });
