import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';

class Conversation extends StatelessWidget {
  DocumentSnapshot chatRoom;
  String otherUserDisplayName;
  Conversation(this.chatRoom, this.otherUserDisplayName);

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      //ToDo //title: otherUserDisplayName,
      child: StreamBuilder(
        stream: Firestore.instance.collection('Chats').document(chatRoom.documentID).get().asStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return FlutterLogo();
        },
      ),
    );
  }
}
