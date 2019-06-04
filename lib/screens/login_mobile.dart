import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/reusable_rounded_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flash_chat/logger.dart';
import '../constants.dart';
import 'package:flash_chat/components/reactive_refresh_indicator.dart';

enum AuthStatus { PHONE_AUTH, SMS_AUTH}

class LoginWithMobile extends StatefulWidget {
  static const id = 'mobile_screen';
  @override
  _LoginWithMobileState createState() => _LoginWithMobileState();
}

class _LoginWithMobileState extends State<LoginWithMobile> {
  static const String TAG = "AUTH";
  AuthStatus status = AuthStatus.PHONE_AUTH;

  // Keys
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  

  // Variables
  // String _phoneNumber;
  // String _errorMessage;
  String _verificationId;
  Timer _codeTimer;
  String smsCode;
  String phoneNumber;

  bool _isRefreshing = false;
  bool _codeTimedOut = false;
  bool _codeVerified = false;
  Duration _timeOut = const Duration(minutes: 1);

  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount _googleUser;
  FirebaseUser _firebaseUser;

  // PhoneVerificationFailed
  verificationFailed(AuthException authException) {
    _showErrorSnackbar(
        "We couldn't verify your code for now, please try again!");
    Logger.log(TAG,
        message:
            'onVerificationFailed, code: ${authException.code}, message: ${authException.message}');
  }

  // PhoneCodeSent
  codeSent(String verificationId, [int forceResendingToken]) async {
    Logger.log(TAG,
        message:
            "Verification code sent to number $phoneNumber");
    _codeTimer = Timer(_timeOut, () {
      setState(() {
        _codeTimedOut = true;
      });
    });
    _updateRefreshing(false);
    setState(() {
      this._verificationId = verificationId;
      this.status = AuthStatus.SMS_AUTH;
      Logger.log(TAG, message: "Changed status to $status");
    });
  }

  // PhoneCodeAutoRetrievalTimeout
  codeAutoRetrievalTimeout(String verificationId) {
    Logger.log(TAG, message: "onCodeTimeout");
    _updateRefreshing(false);
    setState(() {
      this._verificationId = verificationId;
      this._codeTimedOut = true;
    });
  }

  @override
  void dispose() {
    _codeTimer?.cancel();
    super.dispose();
  }

  // async

  Future<Null> _updateRefreshing(bool isRefreshing) async {
    Logger.log(TAG,
        message: "Setting _isRefreshing ($_isRefreshing) to $isRefreshing");
    if (_isRefreshing) {
      setState(() {
        this._isRefreshing = false;
      });
    }
    setState(() {
      this._isRefreshing = isRefreshing;
    });
  }

  _showErrorSnackbar(String message) {
    _updateRefreshing(false);
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<Null> _submitPhoneNumber() async {
    // setState(() {
    //   // _errorMessage = null;
    // });

    final result = await _verifyPhoneNumber();
    Logger.log(TAG, message: "Returning $result from _submitPhoneNumber");
    return result;
  }

  Future<Null> _verifyPhoneNumber() async {
    Logger.log(TAG, message: "Got phone number as: ${this.phoneNumber}");
    await _auth.verifyPhoneNumber(
        phoneNumber: this.phoneNumber,
        timeout: _timeOut,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        verificationCompleted: _linkWithPhoneNumber,
        verificationFailed: verificationFailed);
    Logger.log(TAG, message: "Returning null from _verifyPhoneNumber");
    return null;
  }

  Future<void> _submitSmsCode() async {
    // final error = _smsInputValidator();
    // if (error != null) {
    //   _updateRefreshing(false);
    //   _showErrorSnackbar(error);
    //   return null;
    // } else {
      if (this._codeVerified) {
        await _finishSignIn(await _auth.currentUser());
      } else {
        Logger.log(TAG, message: "_linkWithPhoneNumber called");
        await _linkWithPhoneNumber(
          PhoneAuthProvider.getCredential(
            smsCode: smsCode,
            verificationId: _verificationId,
          ),
        );
      }
      return null;
    // }
  }

  Future<void> _linkWithPhoneNumber(AuthCredential credential) async {
    final errorMessage = "We couldn't verify your code, please try again!";

    _firebaseUser =
        await _auth.signInWithCredential(credential).catchError((error) {
      print("Failed to verify SMS code: $error");
      _showErrorSnackbar(errorMessage);
    });

    // _firebaseUser =
    //     await _firebaseUser.linkWithCredential(credential).catchError((error) {
    //   print("Failed to verify SMS code: $error");
    //   _showErrorSnackbar(errorMessage);
    // });

    await _onCodeVerified(_firebaseUser).then((codeVerified) async {
      this._codeVerified = codeVerified;
      Logger.log(
        TAG,
        message: "Returning ${this._codeVerified} from _onCodeVerified",
      );
      if (this._codeVerified) {
        await _finishSignIn(_firebaseUser);
      } else {
        _showErrorSnackbar(errorMessage);
      }
    });
  }

  Future<bool> _onCodeVerified(FirebaseUser user) async {
    final isUserValid = (user != null &&
        (user.phoneNumber != null && user.phoneNumber.isNotEmpty));
    return isUserValid;
  }

  _finishSignIn(FirebaseUser user) async {
    await _onCodeVerified(user).then((result) {
      if (result) {
        // Here, instead of navigating to another screen, you should do whatever you want
        // as the user is already verified with Firebase from both
        // Google and phone number methods
        // Example: authenticate with your own API, use the data gathered
        // to post your profile/user, etc.

        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (context) => ChatScreen(),
        ));
      } else {
        setState(() {
          this.status = AuthStatus.SMS_AUTH;
        });
        _showErrorSnackbar(
            "We couldn't create your profile for now, please try again later");
      }
    });
  }

  Future<Null> _onRefresh() async {
    switch (this.status) {
      case AuthStatus.PHONE_AUTH:
        return await _submitPhoneNumber();
        break;
      case AuthStatus.SMS_AUTH:
        return await _submitSmsCode();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        child: ReactiveRefreshIndicator(
          onRefresh: _onRefresh,
          isRefreshing: _isRefreshing,
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
                TextField(
                  maxLines: 1,
                  maxLength: 10,
                  onChanged: (mobile) {
                    // bloc.emailChanged(email);
                    phoneNumber = "+91" + mobile;
                  },
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.blueGrey),
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: "(99) 99999-9999",
                    labelText: 'Mobile',
                    // errorText: snapshot.error,
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Hero(
                  tag: 'mobile',
                  transitionOnUserGestures: true,
                  child: ReusableRoundedButtonWidget(
                    buttonLabel: 'Send OTP',
                    fillColor: Colors.deepOrange,
                    onPressed: () async {
                      _updateRefreshing(true);
                      _openOTPVerifier();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _openOTPVerifier() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10.0),
          title: Text("Enter OTP"),
          actions: [
            FlatButton(
              child: Text('RESEND'),
              onPressed: () async {
                if (_codeTimedOut) {
                  await _verifyPhoneNumber();
                } else {
                  _showErrorSnackbar("You can't retry yet!");
                }
              },
            ),
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(()  {
                  Logger.log(TAG, message: 'SUBMIT Clicked');
                  _updateRefreshing(true);
                });
              },
            ),
          ],
          content: TextField(
            onSubmitted: (text) => _updateRefreshing(true),
            onChanged: (_oTP) {
              smsCode = _oTP;
            },
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.blueGrey),
            decoration: kTextFieldDecoration.copyWith(
              hintText: 'OTP',
              labelText: 'OTP',
              // errorText: snapshot.error,
            ),
          ),
        );
      },
    );
  }
}
