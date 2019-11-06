import 'package:flash_chat/screens/channels.dart';
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
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context)=> WelcomeScreen(),
        'login_screen': (context)=> LoginScreen(),
        'registration_screen': (context)=> RegistrationScreen(),
        'chat_screen': (context)=> ChatScreen(),
        'channels': (context)=> Channel(),
      },
    );
  }
}
