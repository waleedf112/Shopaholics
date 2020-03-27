import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Functions/PagePush.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';

import 'Conversation.dart';

ValueNotifier updatedChatPage = new ValueNotifier(TimeOfDay.now());

Future<void> sendPrivateMessage(BuildContext context, String otherUser) async {
  if (!isSignedIn()) {
    final snackBar = SnackBar(
      content: Text('الرجاء تسجيل الدخول لإرسال رسالة', textAlign: TextAlign.right),
      backgroundColor: Colors.black.withOpacity(0.7),
      elevation: 0,
      duration: Duration(seconds: 2),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  } else if (currentUser.uid == otherUser) {
    final snackBar = SnackBar(
      content: Text(
        'لايمكنك ارسال رسالة لنفسك!',
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
      backgroundColor: Colors.black.withOpacity(0.7),
      elevation: 0,
      duration: Duration(seconds: 2),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  } else {
    CollectionReference collectionReference = Firestore.instance.collection("Chats");
    QuerySnapshot querySnapshot;
    String otherUserDisplayName;
    await loadingScreen(
        context: context,
        function: () async {
          querySnapshot = await collectionReference.where('participants', whereIn: [
            [currentUser.uid, otherUser],
            [otherUser, currentUser.uid]
          ]).getDocuments();

          if (querySnapshot.documents.isEmpty)
            await collectionReference.document().setData({
              'participants': [currentUser.uid, otherUser],
            });

          otherUserDisplayName =
              (await Firestore.instance.collection('Users').document(otherUser).get()).data['displayName'];
          Navigator.of(context).pop();
        });

    PagePush(context, Conversation(querySnapshot.documents[0], otherUserDisplayName));
  }
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("Chats")
          .where('participants', arrayContains: currentUser.uid)
          .getDocuments()
          .asStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return FlutterLogo();
      },
    );
  }
}
