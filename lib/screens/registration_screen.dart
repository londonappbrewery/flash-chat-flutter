import 'package:cloud_functions/cloud_functions.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/otherSignIn.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email = '';
  String password = '';
  bool loading = false;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ModalProgressHUD(
        progressIndicator: SpinKitChasingDots(
          color: Theme.of(context).primaryColor,
        ),
        inAsyncCall: loading,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 60.0,
                              child: Image.asset('images/logo.png')),
                          const SizedBox(width: 10.0),
                          Text(
                            'Chateo',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 65),
                          )
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'Hi there! Let\'s Get You Registered',
                    style: kHeadingStyle2(fontSize: 22.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      style: Theme.of(context).textTheme.bodyLarge,
                      cursorColor:
                          Theme.of(context).primaryColorDark.withOpacity(0.6),
                      decoration: getInputDecor('Enter your email')),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    textAlign: TextAlign.left,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (value) {
                      password = value;
                    },
                    style: Theme.of(context).textTheme.bodyLarge,
                    cursorColor:
                        Theme.of(context).primaryColorDark.withOpacity(0.6),
                    decoration: getInputDecor('Enter your password'),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Center(
                    child: Text(
                      'OR',
                      style: kBodyStyle1(color: const Color(0xFFADB5BD)),
                    ),
                  ),
                  getImageButton(
                    'Sign In with Google',
                    context: context,
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      final userCred = await signInWithGoogle();
                      if (userCred.user != null) {
                        Navigator.pushNamed(context, '/update_details');
                      }
                      setState(() {
                        loading = false;
                      });
                    },
                    image: 'google.png',
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  getButton(
                    'Register',
                    context: context,
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      try {
                        final user = await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                        if (user.user != null) {
                          Navigator.pushNamed(context, '/verify');
                        }
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        loading = false;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
