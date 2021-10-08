import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/ButtonWidget.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String loginId = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String mail;
  String pass;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: logoTag,
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              style: TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              onChanged: (value) {
                mail=value;
              },
              decoration: kInputTextDecoration.copyWith(
                hintText: 'Enter your Email.',
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              style: TextStyle(
                color: Colors.black,
              ),
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                pass=value;
              },
              decoration: kInputTextDecoration.copyWith(
                hintText: 'Enter your password.',
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            ButtonWidget(
              color: Colors.lightBlueAccent,
              fun: () async{
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                    email: mail,
                    password: pass,
                  );
                  if (user != null)
                    Navigator.pushNamed(context, ChatScreen.chatId);
                } catch (e) {
                  print(e);
                }
              },
              name: 'Log In',
            ),
          ],
        ),
      ),
    );
  }
}
