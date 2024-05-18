const StreamChat = require("stream-chat").StreamChat;
const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const serverClient = StreamChat.getInstance(
    functions.config().stream.key,
    functions.config().stream.secret);

exports.createStreamUserAndGetToken = functions.https.onCall(
    async (data, context) => {
      if (!context.auth) {
        throw new functions.https.HttpsError(
            "failed-precondition",
            "The function must be called while authenticated.");
      } else {
        try {
          await serverClient.upsertUser({
            id: context.auth.uid,
            name: context.auth.token.name,
            email: context.auth.token.email,
            image: context.auth.token.image,
          });
          return serverClient.createToken(context.auth.uid);
        } catch (err) {
          console.error(
              `Unable to create user with ID ${context.auth.uid} ` +
                `on Stream. Error ${err}`);
          throw new functions.https.HttpsError(
              "aborted",
              "Could not create Stream user");
        }
      }
    });

exports.getStreamUserToken = functions.https.onCall((data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "failed-precondition",
        "The function must be called while authenticated.");
  } else {
    try {
      return serverClient.createToken(context.auth.uid);
    } catch (err) {
      console.error(`Unable to get user token with ID ${context.auth.uid} ` +
            `on Stream. Error ${err}`);
      throw new functions.https.HttpsError("aborted",
          "Could not get Stream user");
    }
  }
});

exports.revokeStreamUserToken = functions.https.onCall((data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("failed-precondition",
        "The function must be called while authenticated.");
  } else {
    try {
      return serverClient.revokeUserToken(context.auth.uid);
    } catch (err) {
      console.error(`Unable to revoke user token with ID ${context.auth.uid} ` +
                `on Stream. Error ${err}`);
      throw new functions.https.HttpsError("aborted",
          "Could not revoke Stream user token");
    }
  }
});

exports.deleteStreamUser = functions.auth.user().onDelete((user, context) => {
  return serverClient.deleteUser(user.uid);
});

