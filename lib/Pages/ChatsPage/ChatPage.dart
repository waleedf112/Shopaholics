import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../Classes/User.dart';
import '../../Functions/PagePush.dart';
import '../../Functions/Translation.dart';
import '../../Widgets/TextWidget.dart';
import '../../Widgets/loadingDialog.dart';
import 'Conversation.dart';
import 'noChatRooms.dart';

ValueNotifier updatedChatPage = new ValueNotifier(DateTime.now().millisecondsSinceEpoch);

Future<void> sendPrivateMessage(BuildContext context, String otherUser) async {
  if (!isSignedIn()) {
    final snackBar = SnackBar(
      content: Text(textTranslation(ar: 'الرجاء تسجيل الدخول لإرسال رسالة', en: ''), textAlign: TextAlign.right),
      backgroundColor: Colors.black.withOpacity(0.7),
      elevation: 0,
      duration: Duration(seconds: 2),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  } else if (currentUser.uid == otherUser) {
    final snackBar = SnackBar(
      content: Text(
        textTranslation(ar: 'لايمكنك ارسال رسالة لنفسك!', en: ''),
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
          querySnapshot = await collectionReference.where('participantsUids', whereIn: [
            [currentUser.uid, otherUser],
            [otherUser, currentUser.uid]
          ]).getDocuments();
          otherUserDisplayName =
              (await Firestore.instance.collection('Users').document(otherUser).get()).data['displayName'];
          if (querySnapshot.documents.isEmpty) {
            await collectionReference.document().setData({
              'participantsUids': [currentUser.uid, otherUser],
              'participantsNames': [currentUser.displayName, otherUserDisplayName],
              'messages': [],
              'latestMessage': null,
            });
            querySnapshot = await collectionReference.where('participantsUids', whereIn: [
              [currentUser.uid, otherUser],
              [otherUser, currentUser.uid]
            ]).getDocuments();
          }
          Navigator.of(context).pop();
        });
    PagePush(context, Conversation(querySnapshot.documents[0].documentID, otherUserDisplayName));
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
        List<DocumentSnapshot> documents = snapshot.data.documents;
        documents.removeWhere((test) => test.data['latestMessage'] == null);
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            String otherUser = documents[index].data['participantsNames'][0];
            if (currentUser.displayName == otherUser) otherUser = documents[index].data['participantsNames'][1];
            return InkWell(
              onTap: () => PagePush(context, Conversation(documents[index].documentID, otherUser)),
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
                                    documents[index].data['latestMessage'],
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
