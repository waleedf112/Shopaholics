import 'dart:async';

import 'package:auto_animated/auto_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/Chat.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

ValueNotifier<int> _messagesCount = ValueNotifier<int>(null);
int _oldMessagesCount = null;

class Conversation extends StatefulWidget {
  final String chatRoom;
  final String otherUserDisplayName;
  Conversation(this.chatRoom, this.otherUserDisplayName);

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController controller = new TextEditingController();
  Timer _timer;
  @override
  void initState() {
    _timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
        setState(() {});

      if (_oldMessagesCount != _messagesCount.value) {
        _oldMessagesCount = _messagesCount.value;
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Interval(0.0, 1.0),
        );
      }
    });
    Future.delayed(Duration(milliseconds: 300)).whenComplete(() {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 150),
        curve: Interval(0, 1),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  ScrollController _controller = ScrollController();

  sendMessage({String message, String receiver}) async {
    if (controller.text.trim().isNotEmpty) {
      String tmp = controller.text.trim();
      controller.text = '';
      FocusScope.of(context).unfocus();
      await Firestore.instance.collection('Chats').document(widget.chatRoom).updateData({
        'messages': FieldValue.arrayUnion([
          {
            'sender': currentUser.uid,
            'message': tmp,
          }
        ]),
        'latestMessage': tmp,
      }).whenComplete(() {
        setState(() {});
        Future.delayed(Duration(seconds: 1)).whenComplete(() {
          _controller.jumpTo(_controller.position.maxScrollExtent);
        });
        print('done');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: widget.otherUserDisplayName,
      backButtonFunction: () {
        _messagesCount.value = null;
        _oldMessagesCount = null;
      },
      child: Container(
        color: Color.fromRGBO(235, 239, 242, 1),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: StreamBuilder(
            stream: Firestore.instance.collection('Chats').document(widget.chatRoom).get().asStream(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) return Container();
              _messagesCount.value = snapshot.data.data['messages'].length;

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.data['messages'].length,
                      itemBuilder: (BuildContext context, int index) {
                        return _SentBubble(ChatMessage(snapshot.data.data['messages'][index]));
                      },
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
                                controller: controller,
                                onSubmitted: (s) => sendMessage(),
                                decoration: InputDecoration(
                                    hintText: 'اكتب رسالتك هنا',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.transparent),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.transparent),
                                    )),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Colors.grey,
                              ),
                              onPressed: () => sendMessage(),
                            )
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
    return Container(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Row(
            mainAxisAlignment: isSent() ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                decoration: BoxDecoration(
                    color: isSent() ? Colors.white : Color.fromRGBO(80, 143, 250, 1),
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
      ),
    );
  }
}
