import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class PersonsScreen extends StatefulWidget {

  static String id = 'persons_screen';

  @override
  _PersonsScreenState createState() => _PersonsScreenState();
}


class _PersonsScreenState extends State<PersonsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              style: kAppBarIcon,
              icon: Image.asset('images/logo.png'),
              //icon: Icon(Icons.close),
              onPressed: () {

                //Implement logout functionality
              }),
        ],
        title: Text('Personen'),
        backgroundColor: Colors.lightBlueAccent.shade700,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
