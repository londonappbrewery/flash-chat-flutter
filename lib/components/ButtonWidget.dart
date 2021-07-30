import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {

  final Color color;
  final String name;
  final Function fun;

  ButtonWidget({this.color,this.fun,this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: this.color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: fun,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            name,
          ),
        ),
      ),
    );
  }
}