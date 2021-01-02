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
      shadowColor: const Color(0xFFCE265A),
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        onPressed: onPressed,
        child: Text(
          labelText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ReusableTextFormField extends StatelessWidget {
  const ReusableTextFormField(
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
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class ReusableLogo extends StatelessWidget {
  const ReusableLogo({this.mq});

  final MediaQueryData mq;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo',
      child: Container(
        alignment: Alignment.center,
        height: mq.size.height / 4,
        child: Image.asset('images/logo.png'),
      ),
    );
  }
}

class ReusableBottomRow extends StatelessWidget {
  const ReusableBottomRow({this.label, this.buttonLabel, this.onPressed});
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
