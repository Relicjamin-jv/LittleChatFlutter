const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

exports.notifyNewMessage = functions.firestore
    .document("messages/{messageID}")
    .onCreate(async (snapshot, context) => {
      const message = snapshot.data();

      let finalMessage = message.text;

      let finalDisplayName = "";

      if (finalMessage.length > 10) {
        finalMessage = finalMessage.substring(0, 9) + "...";
      }

      if (message.photoUrl != "") {
        finalMessage = "Image...";
      }

      await db.collection("users").doc(message.sentBy).get().then((value) => {
        finalDisplayName = value.data()["displayName"];
      });

      const payload = {
        notification: {
          title: message.displayName,
          body: finalDisplayName + ": " + finalMessage,
        },
      };
      let groupID = "Before";

      const docID = context.params.messageID;

      await db
          .collection("messages")
          .doc(docID)
          .get()
          .then((value) => {
            groupID = value.data()["groupUid"];
          });

      await db
          .collection("users")
          .where("groups", "array-contains", groupID)
          .get()
          .then((value) => {
            value.docs.forEach((doc) => {
              fcm.sendToDevice(doc.data()["deviceId"], payload);
            });
          });
      return;
    });
