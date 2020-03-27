import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Functions/PagePush.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';

import 'Conversation.dart';
import 'noChatRooms.dart';

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
          otherUserDisplayName =
              (await Firestore.instance.collection('Users').document(otherUser).get()).data['displayName'];
          if (querySnapshot.documents.isEmpty)
            await collectionReference.document().setData({
              'participantsUids': [currentUser.uid, otherUser],
              'participantsNames': [currentUser.displayName, otherUserDisplayName],
            });
          Navigator.of(context).pop();
        });

    PagePush(context, Conversation(querySnapshot.documents[0], otherUserDisplayName));
  }
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!isSignedIn()) return NoChatRooms();
    return StreamBuilder(
      stream: Firestore.instance
          .collection("Chats")
          .where('participantsUids', arrayContains: currentUser.uid)
          .getDocuments()
          .asStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return SpinKitRotatingCircle(color: Colors.grey.withOpacity(0.3));
        if (snapshot.data.documents.isEmpty) return NoChatRooms();
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            String otherUser = snapshot.data.documents[index].data['participantsNames'][0];
            if (currentUser.displayName == otherUser)
              otherUser = snapshot.data.documents[index].data['participantsNames'][1];
            return InkWell(
              onTap: () => PagePush(context, Conversation(snapshot.data.documents[index], otherUser)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: BorderDirectional(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.4)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.3,
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/default_avatar.png'),
                            backgroundColor: Colors.white,
                            radius: 25,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  otherUser,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextWidget(
                                    snapshot.data.documents[index].data['latestMessage'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    maxFontSize: 12,
                                    minFontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
