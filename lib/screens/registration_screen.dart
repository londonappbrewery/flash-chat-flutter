import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/Bloc_email_password/block.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/reusable_rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isSpinnerEnabled = false;
  String email;
  String password;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // FirebaseUser currentUser = firebaseAuth.currentUser();

  registerUser(String email, String password) async {
    setState(() {
      isSpinnerEnabled = true;
    });
    try {
      
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (firebaseAuth.currentUser() != null) {
        setState(() {
          isSpinnerEnabled = false;
        });
        // Navigator.pushReplacementNamed(context, ChatScreen.id);
        Navigator.of(context)
    .pushNamedAndRemoveUntil(ChatScreen.id, (Route<dynamic> route) => false);
      }
    } catch (e) {
      setState(() {
        isSpinnerEnabled = false;
      });
      print(e);
    }
  }

  var bloc = Bloc();

  @override
  Widget build(BuildContext context) {
    // var bloc = Provider.of(context).bloc;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isSpinnerEnabled,
        child: Padding(
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
              StreamBuilder<String>(
                stream: bloc.email,
                builder: (context, snapshot) => TextField(
                      onChanged: (email) {
                        bloc.emailChanged(email);
                        this.email = email;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.blueGrey),
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'you@example.com',
                          labelText: 'Email',
                          errorText: snapshot.error),
                    ),
              ),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder<String>(
                  stream: bloc.password,
                  builder: (context, snapshot) {
                    return TextField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      onChanged: (password) {
                        bloc.passwordChanged(password);
                        this.password = password;
                      },
                      style: TextStyle(color: Colors.blueGrey),
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter password',
                        labelText: 'Password',
                        errorText: snapshot.error,
                      ),
                    );
                  }),
              SizedBox(
                height: 24.0,
              ),
              StreamBuilder<bool>(
                stream: bloc.submitCheck,
                builder: (context, snapshot) => Hero(
                      tag: 'register',
                      transitionOnUserGestures: true,
                      child: ReusableRoundedButtonWidget(
                        buttonLabel: 'Register',
                        fillColor: Colors.blueAccent,
                        onPressed: snapshot.hasData
                            ? () {
                                registerUser(email, password);
                              }
                            : null,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
