import 'package:flash_chat/constants.dart';
import 'package:flash_chat/theme.dart';
import 'package:flutter/material.dart';

class GlowingActionButton extends StatelessWidget {
  const GlowingActionButton(
      {super.key,
      required this.size,
      required this.color,
      required this.icon,
      required this.onPressed,
      this.iconSize,
      this.iconColor});
  final double size;
  final Color color;
  final IconData icon;
  final double? iconSize;
  final Color? iconColor;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.2), spreadRadius: 10, blurRadius: 24)
          ],
          shape: BoxShape.circle),
      child: ClipOval(
        child: Material(
          color: color,
          child: InkWell(
            onTap: onPressed,
            splashColor: AppColors.darkCardColor,
            child: SizedBox(
                width: size,
                height: size,
                child: Icon(icon,
                    size: iconSize ?? size / 2, color: iconColor ?? kWhite)),
          ),
        ),
      ),
    );
  }
}
