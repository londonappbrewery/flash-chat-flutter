/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */


if (process.env.NODE_ENV !== 'production') {
  require('dotenv').config();
}
const StreamChat = require('stream-chat').StreamChat;
const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const serverClient = StreamChat.getInstance(process.env.STREAM_KEY, process.env.STREAM_SECRET);


// When a user is deleted from Firebase their associated Stream account is also deleted.
exports.deleteStreamUser = functions.auth.user().onDelete((user, context) => {
  console.log(user.uid);
  return serverClient.deleteUser(user.uid);
});

// Create a Stream user and return auth token.
exports.createStreamUserAndGetToken = functions.https.onCall(async (data, context) => {
  // Checking that the user is authenticated.
  if (!context.auth) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
      'while authenticated.');
  } else {
    try {
      // Create user using the serverClient.
      await serverClient.upsertUser({
        id: context.auth.uid,
        name: context.auth.token.name,
        email: context.auth.token.email,
        image: context.auth.token.picture,
      });

      /// Create and return user auth token.
      return serverClient.createToken(context.auth.uid);
    } catch (err) {
      console.error(`Unable to create user with ID ${context.auth.uid} on Stream. Error ${err}`);
      // Throwing an HttpsError so that the client gets the error details.
      throw new functions.https.HttpsError('aborted', "Could not create Stream user");
    }
  }
});

// Get Stream user token.
exports.getStreamUserToken = functions.https.onCall((data, context) => {
  // Checking that the user is authenticated.
  if (!context.auth) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
      'while authenticated.');
  } else {
    try {
      return serverClient.createToken(context.auth.uid);
    } catch (err) {
      console.error(`Unable to get user token with ID ${context.auth.uid} on Stream. Error ${err}`);
      // Throwing an HttpsError so that the client gets the error details.
      throw new functions.https.HttpsError('aborted', "Could not get Stream user");
    }
  }
});

// Revoke the authenticated user's Stream chat token.
exports.revokeStreamUserToken = functions.https.onCall((data, context) => {
  // Checking that the user is authenticated.
  if (!context.auth) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
      'while authenticated.');
  } else {
    try {
      return serverClient.revokeUserToken(context.auth.uid);
    } catch (err) {
      console.error(`Unable to revoke user token with ID ${context.auth.uid} on Stream. Error ${err}`);
      // Throwing an HttpsError so that the client gets the error details.
      throw new functions.https.HttpsError('aborted', "Could not get Stream user");
    }
  }
});


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
