import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: WelcomeScreen.WELCOME_SCREEN_ROUTE,
      routes: {
        RegistrationScreen.REGISTRATION_SCREEN_ROUTE: (context) => RegistrationScreen(),
        ChatScreen.CHAT_SCREEN_ROUTE: (context) => ChatScreen(),
        WelcomeScreen.WELCOME_SCREEN_ROUTE: (context) => WelcomeScreen(),
        LoginScreen.LOGIN_SCREEN_ROUTE: (context) => LoginScreen(),
      },
    );
  }
}
