import 'package:flash_chat/reusable_widgets.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color(0xff8c52ff),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(36),
          child: Container(
            height: mq.size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ReusableLogo(
                  mq: mq,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ReusableTextFormField(
                        controller: _emailController,
                        labelText: 'Email',
                        type: TextInputType.emailAddress,
                      ),
                      ReusableTextFormField(
                        labelText: 'Password',
                        controller: _passwordController,
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 150.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ReusableMaterialButton(
                        labelText: 'Login',
                        mq: mq,
                        onPressed: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                      ),
                      ReusableBottomRow(
                        label: 'Not a member?',
                        buttonLabel: 'Sign Up',
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(RegistrationScreen.id);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
