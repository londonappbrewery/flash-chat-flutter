import 'package:flutter/material.dart';

class ReusableRoundedButtonWidget extends StatelessWidget {
  
  ReusableRoundedButtonWidget({@required this.buttonLabel, @required this.onPressed, this.fillColor});

  final String buttonLabel;
  final Function onPressed;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        height: 50.0,
        child: RawMaterialButton(
          elevation: 5.0,
          onPressed: onPressed,
          fillColor: fillColor ?? Colors.blueAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Text(
            buttonLabel,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}