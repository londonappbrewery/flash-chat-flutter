import 'package:flash_chat/reusable_widgets.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Color(0xFFCE265A),
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
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ReusableTextFormField(
                        labelText: 'Username',
                        controller: _usernameController,
                      ),
                      ReusableTextFormField(
                        labelText: 'Email',
                        controller: _emailController,
                        type: TextInputType.emailAddress,
                      ),
                      ReusableTextFormField(
                        labelText: 'Password',
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      ReusableTextFormField(
                        labelText: 'Re-enter Password',
                        obscureText: true,
                        controller: _repasswordController,
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
                        labelText: 'Register',
                        mq: mq,
                        onPressed: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                      ),
                      ReusableBottomRow(
                        label: 'Already have an account?',
                        buttonLabel: 'Login',
                        onPressed: () {
                          Navigator.of(context).pushNamed(LoginScreen.id);
                        },
                      )
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
