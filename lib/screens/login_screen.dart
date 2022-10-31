import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/navigate_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authObject = FirebaseAuth.instance;
  String email;
  String pwd;
  bool load = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: load,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                    //Do something with the user input.
                  },
                  decoration:
                      kButtonDecoration.copyWith(hintText: 'Enter your Email')),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  obscureText: true,
                  obscuringCharacter: '*',
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    pwd = value;
                    //Do something with the user input.
                  },
                  decoration: kButtonDecoration.copyWith(
                      hintText: 'Enter your Password')),
              SizedBox(
                height: 24.0,
              ),
              NavigateButton(
                  title: 'Log In',
                  color: Colors.lightBlueAccent,
                  onPressed: () async {
                    setState(() {
                      load = true;
                    });
                    try {
                      final userExist =
                          await _authObject.signInWithEmailAndPassword(
                              email: email, password: pwd);
                      if (userExist != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                      setState(() {
                        load = false;
                      });
                    } catch (e) {
                      log(e);
                      log('wrong email add');
                      setState(() {
                        log('try again');
                        load = false;
                      });
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
