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
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.welcomId,
      routes: {
        WelcomeScreen.welcomId: (context) => WelcomeScreen(),
        LoginScreen.loginId: (context) => LoginScreen(),
        ChatScreen.chatId: (context) => ChatScreen(),
        RegistrationScreen.regId: (context) => RegistrationScreen(),
      },
    );
  }
}
