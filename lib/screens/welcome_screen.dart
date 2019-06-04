import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/reusable_rounded_button.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();

    setState(() {
      checkUser();
    });
    
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1)
    );

    animation = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white
    ).animate(animationController);

    animationController.forward();

    animationController.addListener(() {
      setState(() {
//        print(animationController.value);
        print(animation.value);
      });
    });

  }

  checkUser() async {
    var user = await FirebaseAuth.instance.currentUser();
    if (user != null ){

      setState(() {
        Navigator.pushReplacementNamed(context, ChatScreen.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  transitionOnUserGestures: true,
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Hero(
              tag: 'login',
              transitionOnUserGestures: true,
              child: ReusableRoundedButtonWidget(
                fillColor: Colors.lightBlueAccent,
                buttonLabel: 'Log In',
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
            ),
            Hero(
              tag: 'register',
              transitionOnUserGestures: true,
              child: ReusableRoundedButtonWidget(
                buttonLabel: 'Register',
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
            ),
            Hero(
              tag: 'mobile',
              transitionOnUserGestures: true,
              child: ReusableRoundedButtonWidget(
                fillColor: Colors.deepOrange,
                buttonLabel: 'Login With Mobile',
                onPressed: () {
                  Navigator.pushNamed(context, LoginWithMobile.id);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

}
