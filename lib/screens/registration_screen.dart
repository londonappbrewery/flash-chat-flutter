import 'dart:developer';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/navigate_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = '/registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
                height: 4.0,
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
                height: 6.0,
              ),
              NavigateButton(
                  title: 'Register',
                  color: Colors.blueAccent,
                  onPressed: () async {
                    setState(() {
                      load = true;
                    });

                    final UserCredential newUser =
                        await _authObject.createUserWithEmailAndPassword(
                            email: email, password: pwd);

                    try {
                      if (newUser != null) {
                        
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                      setState(() {
                        load = false;
                      });
                    } catch (e) {
                      log(e.toString());
                      log('failed to add account');
                      load = true;
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
