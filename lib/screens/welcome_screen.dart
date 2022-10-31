import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/navigate_button.dart';
// import 'dart:developer';

class WelcomeScreen extends StatefulWidget {
  static const String id = '/';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animate;

  @override
  void initState() {
    controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this, upperBound: 1);
    animate = CurvedAnimation(parent: controller, curve: Curves.easeInCubic);

    // animate = CurvedAnimation(parent: controller, curve: Curves.bounceIn);
    // animate.addListener(() {
    //   log('${controller.value}, ${animate.value}');
    //   setState(() {});
    // });
    // controller.forward();
    // controller.addStatusListener((status) {
    //   if (controller.isCompleted) {
    //     controller.reverse(from: 1);
    //   }
    //   if (controller.isDismissed) {
    //     controller.forward();
    //   }
    // });
    super.initState();
  }

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
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    height:
                        100, //animate is applied over controller that's why we're not using controller.value(linear progress)
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText('Flash Chat',
                        curve: Curves.easeOut,
                        speed: Duration(milliseconds: 150),
                        textStyle: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                        ))
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            NavigateButton(
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
                //Go to login screen.
              },
              title: 'Log In',
            ),
            NavigateButton(
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
                //Go to registration screen.
              },
              title: 'Register',
              color: Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }
}
