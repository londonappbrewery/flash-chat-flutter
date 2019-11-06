import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//var global
final _firestore = Firestore.instance;
FirebaseUser loggedInUser;


//chat stream beginning
class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  final messageTextController = TextEditingController();

  String messageText;

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    try {
      if (user != null){
        loggedInUser = user;
        print(loggedInUser.email);
      }
    }
    catch (e){
      print(e);
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                //messagesStream();
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            MessageStream(),

            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
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

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final bool isMe;
  final sender;
  final text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ?CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black45
            ),
          ),
          Material(
            borderRadius: isMe ? BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ) : BorderRadius.only(topRight: Radius.circular(30.0), bottomRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Colors.blueAccent : Colors.white,
            child:
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
          '$text',
                  style: TextStyle(
                    color: isMe ?Colors.white : Colors.black45,
                    fontSize: 20.0,
                  ),
          ),
              ),
          ),
        ],
      ),
    );
  }

  }



  class MessageStream extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context, snapshot){
          if (snapshot.hasData){
            final messages = snapshot.data.documents.reversed;
            List<MessageBubble> messageBubbles = [];
            for (var message in messages){
              final messageText = message.data['text'];
              final messageSender = message.data['sender'];

              final currentUser = loggedInUser.email;

              final messageBubble = MessageBubble(
                text: messageText,
                sender: messageSender,
                isMe: currentUser == messageSender,

              );
              messageBubbles.add(messageBubble);
            }
            return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                children: messageBubbles,
              ),
            );
          } else if (!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    }
  }


/*void getMessages() async {
    final messages = await _firestore.collection('messages').getDocuments();
    for (var mess in messages.documents){
      print(mess.data);
    }
  }*/
/*
  void messagesStream() async {
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for (var message in snapshot.documents){
        print(message.data);
      }
    }
  }
  */