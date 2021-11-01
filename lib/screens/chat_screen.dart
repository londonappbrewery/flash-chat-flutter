import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestoreObject = FirebaseFirestore.instance;
User loggedInUser;
final scrollController = ScrollController();

class ChatScreen extends StatefulWidget {
  static const String id = '/chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final _authObject = FirebaseAuth.instance;
  String msg;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final currentUser = _authObject.currentUser;
      if (currentUser != null) {
        loggedInUser = currentUser;
        log(loggedInUser.email);
        log("init");
      }
    } catch (e) {
      log(e);
    } //Implement send functionality.
  }

  // void messageStream() async {
  //   await for (var snapshot
  //       in _firestoreObject.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) {}
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _authObject.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.blue,
        elevation: 10,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStreamBuilder(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onTap: () {
                        scrollController.jumpTo(1);
                      },
                      controller: messageController,
                      onChanged: (value) {
                        msg = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageController.clear();
                      scrollController.jumpTo(1);
                      _firestoreObject.collection('messages').add({
                        'text': msg,
                        'sender': loggedInUser.email,
                        'timestamp': FieldValue.serverTimestamp()
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  //const MessageStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestoreObject
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final messages = snapshot.data.docs;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageSender = message.get('sender');
            final messageText = message.get('text');

            final currentUser = loggedInUser.email;

            final messageBubble = MessageBubble(
                text: messageText,
                sender: messageSender,
                isMe: messageSender == currentUser);

            messageBubbles.add(messageBubble);
          }

          return Expanded(
            child: ListView(
              controller: scrollController,
              reverse: true,
              children: messageBubbles,
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  final text;
  final sender;
  final isMe;

  MessageBubble({this.text, this.sender, this.isMe});
  //const MessageBubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
        child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                '$sender',
                textAlign: isMe ? TextAlign.right : TextAlign.left,
              ),
              Material(
                elevation: 5.0,
                borderRadius: isMe
                    ? BorderRadius.only(
                        bottomRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(25.0))
                    : BorderRadius.only(
                        bottomRight: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(25.0)),
                color: isMe ? Colors.blue[800] : Colors.blue,
                //alignment: Alignment.center,
                child: Padding(
                  padding: isMe
                      ? EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 15.0)
                      : EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 15.0),
                  child: Text(
                    '$text',
                    style: TextStyle(
                        wordSpacing: 1.5,
                        letterSpacing: 0.4,
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ]));
  }
}
// Container(
// decoration: BoxDecoration(
// color: Colors.blue,
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(10.0),
// bottomLeft: Radius.circular(10.0),
// bottomRight: Radius.circular(10.0))),
// padding: EdgeInsets.all(10.0),

// Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// Text(
// '$sender',
// style: TextStyle(),
// textAlign: TextAlign.left,
// ),
// Material(
// elevation: 6.0,
// borderRadius: BorderRadius.only(
// bottomRight: Radius.circular(20.0),
// topRight: Radius.circular(20.0),
// bottomLeft: Radius.circular(25.0)),
// color: Colors.blue,
// //alignment: Alignment.center,
// child: Padding(
// padding: EdgeInsets.only(
// left: 22.0, right: 20.0, top: 10.0, bottom: 15.0),
// child: Text(
// '$text',
// style: TextStyle(
// wordSpacing: 1.5,
// letterSpacing: 0.4,
// color: Colors.white,
// fontSize: 17.0,
// fontWeight: FontWeight.w600),
// ),
// ),
// ),
// ]),
