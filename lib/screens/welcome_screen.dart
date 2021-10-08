import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/ButtonWidget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String welcomId = 'welcom';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
      // upperBound: 60.0,
    );

    //this is curved animation
    // animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn);

    // animation.addStatusListener((status) {
    //   if (animation.isCompleted)
    //     controller.reverse(from: 1.0);
    //   else if (animation.isDismissed) controller.forward();
    // });

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: logoTag,
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 60.0,
                    ),
                  ),
                ),
                DefaultTextStyle(
                  style:TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color:Colors.blue[700],
                    ) ,
                  child: AnimatedTextKit(
                    animatedTexts: [WavyAnimatedText('Flash Chat')],
                    displayFullTextOnTap:true,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ButtonWidget(
              name: 'Log In',
              color: Colors.lightBlueAccent,
              fun: () {
                //Go to login screen.
                Navigator.pushNamed(context, LoginScreen.loginId);
              },
            ),
            ButtonWidget(
              color: Colors.blueAccent,
              fun: () {
                //Go to registration screen.
                Navigator.pushNamed(context, RegistrationScreen.regId);
              },
              name: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
