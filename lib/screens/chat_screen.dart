import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  final _firestore = Firestore.instance;

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

  /*void getMessages() async {
    final messages = await _firestore.collection('messages').getDocuments();
    for (var mess in messages.documents){
      print(mess.data);
    }
  }*/

  void messagesStream() async {
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for (var message in snapshot.documents){
        print(message.data);
      }
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
                messagesStream();
                /*_auth.signOut();
                Navigator.pop(context);*/
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
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, snapshot){
                if (snapshot.hasData){
                  final messages = snapshot.data.documents;
                  List<Text> messageWidgets = [];
                  for (var message in messages){
                    final messageText = message.data['text'];
                    final messageSender = message.data['sender'];

                    final messageWidget = Text(
                      '$messageText from $messageSender'
                    );
                    messageWidgets.add(messageWidget);
                  }
                  return Column(
                    children: messageWidgets,
                  );
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
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
