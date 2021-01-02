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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFCE265A),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(36),
          child: Container(
            height: mq.size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ReusableLogo(
                  mq: mq,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
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
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 150.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Hero(
                        tag: 'login_button',
                        child: ReusableMaterialButton(
                          labelText: 'Login',
                          mq: mq,
                          onPressed: () {},
                        ),
                      ),
                      const Padding(
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
