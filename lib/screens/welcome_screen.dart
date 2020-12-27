import 'package:flash_chat/reusable_widgets.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      //backgroundColor: Color(0xff8c52ff),
      backgroundColor: Color(0xFFCE265A),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: ReusableLogo(mq: mq),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
              child: Text(
                'Hello There!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'login_button',
                    child: ReusableMaterialButton(
                      mq: mq,
                      labelText: 'Login',
                      onPressed: () {
                        Navigator.of(context).pushNamed(LoginScreen.id);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 70),
                    child: ReusableMaterialButton(
                      mq: mq,
                      labelText: 'Register',
                      onPressed: () {
                        Navigator.of(context).pushNamed(RegistrationScreen.id);
                      },
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
