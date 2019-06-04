import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/Message_Bloc/message.dart';
import 'package:flash_chat/Message_Bloc/messageBloc.dart';
import 'package:flash_chat/logger.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

Firestore firestore = Firestore.instance;

class _ChatScreenState extends State<ChatScreen> {
  var auth = FirebaseAuth.instance;
  String message;

  FirebaseUser firebaseUser;

  TextEditingController textController = TextEditingController();

  getFirebaseUser() async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
  }

  Future<void> sendMessage() async =>
      await firestore.collection('message').add({
        'sender': firebaseUser.email ?? firebaseUser.phoneNumber,
        'text': message
      });

  signOutUser() async {
    await auth.signOut();
    setState(() {
      // Navigator.of(context).popUntil(ModalRoute.withName(WelcomeScreen.id));
      Navigator.of(context).pushNamedAndRemoveUntil(
          WelcomeScreen.id, (Route<dynamic> route) => false);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFirebaseUser();
  }

  @override
  Widget build(BuildContext context) {
    final MessagesBloc messagesBloc = Provider.of<MessagesBloc>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                signOutUser();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Flexible(child: MessagesListViewBuilder(messagesBloc.messageModel)),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        this.message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      textController.clear();
                      if (message.isNotEmpty) {
                        await sendMessage();
                        Logger.log('Message', message: 'Message sent');
                      }
                      //Implement send functionality.
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

class MessagesListViewBuilder extends StatelessWidget {
  final List<Message> messageModelList;

  MessagesListViewBuilder(this.messageModelList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messageModelList.length,
      itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  messageModelList[index].sender,
                  style: TextStyle(
                    color: Colors.black26,
                  ),
                ),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Colors.lightBlueAccent,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      messageModelList[index].text,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
