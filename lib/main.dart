import 'package:flash_chat/Message_Bloc/messageBloc.dart';
import 'package:flash_chat/screens/login_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MessagesBloc>.value(
      notifier: MessagesBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
//      theme: ThemeData.dark().copyWith(
//        textTheme: TextTheme(
//          body1: TextStyle(color: Colors.black54),
//        ),
//      ),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(false),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          ChatScreen.id: (context) => ChatScreen(),
          LoginWithMobile.id: (context) => LoginWithMobile(),
        },
      ),
    );
  }
}
