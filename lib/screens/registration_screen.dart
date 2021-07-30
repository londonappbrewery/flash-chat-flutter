import 'package:flash_chat/components/ButtonWidget.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  static const String regId = 'register';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: kInputTextDecoration.copyWith(
                hintText: 'Enter your Email.',
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: kInputTextDecoration.copyWith(
                hintText: 'Enter your password.',
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            ButtonWidget(
              name: 'Register',
              color: Colors.blueAccent,
              fun: () {},
            ),
          ],
        ),
      ),
    );
  }
}
