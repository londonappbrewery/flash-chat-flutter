import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Notifications Screen', style: kBodyStyle1(color: Theme.of(context).primaryColorDark)),
    );
  }
}
