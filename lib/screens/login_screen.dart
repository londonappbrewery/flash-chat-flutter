import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/reusable_rounded_button.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              tag: 'logo',
              transitionOnUserGestures: true,
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
              style: TextStyle(
                  color: Colors.blueGrey
              ),
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter email',
                labelText: 'Email',
//                errorText: ""
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              style: TextStyle(
                  color: Colors.blueGrey
              ),
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter password.',
                labelText: 'Password'
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Hero(
              tag: 'login',
              transitionOnUserGestures: true,
              child: ReusableRoundedButtonWidget(
                buttonLabel: 'Log In',
                fillColor: Colors.lightBlueAccent,
                onPressed: () {
                  //Implement login functionality.
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
