import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

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
                Hero(
                  tag: 'logo',
                  child: Container(
                    alignment: Alignment.center,
                    child: Image.asset('images/logo.png'),
                    height: mq.size.height / 4,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          hintText: "John Doe",
                          labelText: "Username",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          hintText: "something@example.com",
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          hintText: "password",
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _repasswordController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          hintText: "password",
                          labelText: "Re-enter Password",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
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
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.white,
                        child: MaterialButton(
                          minWidth: mq.size.width / 1.2,
                          padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                          child: Text(
                            "Register",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {},
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Already have an account?",
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(LoginScreen.id);
                            },
                            child: Text(
                              "Login",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ],
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
