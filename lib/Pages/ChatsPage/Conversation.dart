import 'dart:async';

import 'package:auto_animated/auto_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/Chat.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation extends StatefulWidget {
  final String chatRoom;
  final String otherUserDisplayName;
  Conversation(this.chatRoom, this.otherUserDisplayName);

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  Timer _timer;
  @override
  void initState() {
    _timer = new Timer.periodic(Duration(seconds: 3), (Timer timer) {
      setState(() {
        print(DateTime.now().millisecondsSinceEpoch);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: widget.otherUserDisplayName,
      child: Container(
        color: Color.fromRGBO(235, 239, 242, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: Firestore.instance.collection('Chats').document(widget.chatRoom).get().asStream(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) return Container();
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  LiveList(
                    shrinkWrap: true,
                    itemCount: snapshot.data.data['messages'].length,
                    itemBuilder: (BuildContext context, int index, Animation<double> animation) => FadeTransition(
                      opacity: Tween<double>(
                        begin: 0,
                        end: 1,
                      ).animate(animation),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, -0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: _SentBubble(new ChatMessage(snapshot.data.data['messages'][index])),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'اكتب رسالتك هنا',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(icon: Icon(Icons.send,color: Colors.grey,), onPressed: (){})
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SentBubble extends StatelessWidget {
  ChatMessage chat;
  _SentBubble(this.chat);

  bool isSent() => chat.sender == currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: isSent() ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: isSent() ? Colors.white : Color.fromRGBO(80, 143, 250, 1),
                  borderRadius: BorderRadius.circular(50)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  chat.message,
                  style: TextStyle(
                    color: isSent() ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
