import 'package:flash_chat/Bloc_email_password/block.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/reusable_rounded_button.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  printsomething() {
    print('something');
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Bloc();

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
            StreamBuilder<String>(
              stream: bloc.email,
              builder: (context, snapshot) => TextField(
                    onChanged: bloc.emailChanged,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.blueGrey),
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter email',
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
                  onChanged: bloc.passwordChanged,
                  style: TextStyle(color: Colors.blueGrey),
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter password.',
                    labelText: 'Password',
                    errorText: snapshot.error,
                  ),
                );
              }
            ),
            SizedBox(
              height: 24.0,
            ),
            StreamBuilder<bool>(
              stream: bloc.submitCheck,
              builder: (context, snapshot) => Hero(
                    tag: 'login',
                    transitionOnUserGestures: true,
                    child: ReusableRoundedButtonWidget(
                      buttonLabel: 'Log In',
                      fillColor: Colors.lightBlueAccent,
                      onPressed: () => {
                        
                      },
                      // onPressed: snapshot.hasData ? (() => {printsomething()}) : null,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
