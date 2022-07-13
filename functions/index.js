const functions = require("firebase-functions");
const admin = require("firebase-admin");

// firebase-adminの初期化
admin.initializeApp();

exports.deleteUser = functions
    .region("asia-northeast1")
    .firestore.document("deleted_users/{docId}")
    .onCreate(async (snap, context) => {
      const deleteDocument = snap.data();
      const uid = deleteDocument.uid;

      // Authenticationのユーザーを削除する
      await admin.auth().deleteUser(uid);
    });


    //Welcome Email
    //参考　https://morioh.com/p/ed131b650c9b
//SendGridヘルパーライブラリ（メールを送るAPI）
const sgMail = require('@sendgrid/mail')
sgMail.setApiKey(functions.config().sendgrid.key);



    exports.sendWelcomeEmail = functions.auth.user().onCreate((user) => {
      const email = user.email; // ユーザーのメールアドレスを取得する。
      const displayName = user.displayName; // ユーザーの名前を取得する。

      const msg = {
        to: email,
        from: "Dance4Life<at4forfor@gmail.com>", // Change to your verified sender email
        subject: "Welcome to Dance4Life",
        text: `この度はダウンロードいただきありがとうございます。\n使用上至らない点等があるかとはございますが、これから機能等を充実させていこうと思います。\n温かい目で見ていただけると幸いです。今後とも何卒よろしくお願いいたいします。\nATSUSHI KADOWAKI`,
      };

      sgMail
          .send(msg)
          .then((response) => {
            console.log(response[0].statusCode);
            console.log(response[0].headers);
          })
          .catch((error) => {
            console.error(`Unable to send email. Error: ${error}`);
            throw new functions.https.HttpsError("aborted", "Unable to send email");
          });

      return `Email sent successfully to ${msg.to}`;
    });