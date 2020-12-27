import 'package:flutter/material.dart';

class ReusableMaterialButton extends StatelessWidget {
  const ReusableMaterialButton({this.mq, this.labelText, this.onPressed});

  final MediaQueryData mq;
  final String labelText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      shadowColor: Color(0xFFCE265A),
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(
          labelText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class ReusableTextFormField extends StatelessWidget {
  ReusableTextFormField(
      {this.controller, this.labelText, this.type, this.obscureText = false});

  final TextEditingController controller;
  final String labelText;
  final TextInputType type;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      keyboardType: type,
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
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class ReusableLogo extends StatelessWidget {
  ReusableLogo({this.mq});

  final MediaQueryData mq;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo',
      child: Container(
        alignment: Alignment.center,
        child: Image.asset('images/logo.png'),
        height: mq.size.height / 4,
      ),
    );
  }
}

class ReusableBottomRow extends StatelessWidget {
  ReusableBottomRow({this.label, this.buttonLabel, this.onPressed});
  final String label;
  final String buttonLabel;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: Colors.white,
              ),
        ),
        MaterialButton(
          onPressed: onPressed,
          child: Text(
            buttonLabel,
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
          ),
        ),
      ],
    );
  }
}
