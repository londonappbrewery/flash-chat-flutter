import 'dart:async';
import 'package:flash_chat/Bloc_email_password/validator.dart';
import 'package:rxdart/rxdart.dart';

class Bloc extends Object with Validators implements BaseBloc{

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;

  //Another way
  // StreamSink<String> get emailChanged => _emailController.sink;
  // StreamSink<String> get passwordChanged => _passwordController.sink;

  Stream<String> get email => _emailController.stream.transform(emailValidator);
  Stream<String> get password => _passwordController.stream.transform(passwordValidator);

  Stream<bool> get submitCheck => Observable.combineLatest2(email, password, (e, p) => true);

  @override
  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }

}

abstract class BaseBloc {
  dispose();
}