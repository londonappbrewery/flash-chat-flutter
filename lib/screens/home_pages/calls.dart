import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Calls Screen', style: kBodyStyle1(color: Theme.of(context).primaryColorDark)),
    );
  }
}
