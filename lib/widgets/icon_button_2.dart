import 'package:flutter/material.dart';

class IconButton2 extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? splashColor;
  const IconButton2(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.splashColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(6.0),
      child: InkWell(
        onTap: onPressed,
        splashColor: splashColor ?? Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: Theme.of(context).iconTheme.color, size: 18),
        ),
      ),
    );
  }
}

class IconButtonBorder extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? splashColor;
  const IconButtonBorder(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.splashColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Theme.of(context).disabledColor),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: InkWell(
        onTap: onPressed,
        splashColor: splashColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(6.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: Theme.of(context).iconTheme.color, size: 18),
        ),
      ),
    );
  }
}
