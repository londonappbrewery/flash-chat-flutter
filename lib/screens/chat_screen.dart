import 'package:flash_chat/models/models.dart';
import 'package:flash_chat/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final messageData =
        ModalRoute.of(context)!.settings.arguments as MessageData;
    return Scaffold(
        appBar: AppBar(
          leading: Align(
            alignment: Alignment.centerRight,
            child: Avatar.medium(imageUrl: messageData.profilePicture),
          ),
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    messageData.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    'Online',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500, color: kGreen),
                  )
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButtonBorder(
                  onPressed: () {}, icon: CupertinoIcons.video_camera),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
              child: IconButtonBorder(
                  onPressed: () {}, icon: CupertinoIcons.phone),
            ),
          ],
        ),
        body: const Column(
          children: [Expanded(child: _MessageList()), _ActionBar()],
        ));
  }
}

class _MessageList extends StatefulWidget {
  const _MessageList({super.key});

  @override
  State<_MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<_MessageList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView(
        children: const [
          DateLabel(label: "Yesterday"),
          _Message(message: "Hi Meesum", date: "21/7/23"),
          _Message(message: "Hello there", date: "21/7/23", byMe: true),
          _Message(
              message:
                  "I have heard that you are developing a stupid chat application",
              date: "21/7/23"),
          _Message(message: "How's it going?", date: "21/7/23"),
          _Message(
            message:
                "Ahhh yess, Chateo. It is such a wonderful app and the Ui is almost ready. this is the last thing I need to complete",
            date: "21/7/23",
            byMe: true,
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final String message;
  final String date;
  final bool byMe;
  static const double radius = 16;
  const _Message(
      {super.key,
      required this.message,
      required this.date,
      this.byMe = false});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Align(
      alignment: byMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            byMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: byMe
                ? BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(radius),
                      bottomLeft: Radius.circular(radius),
                      topLeft: Radius.circular(radius),
                    ),
                  )
                : BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(radius),
                      bottomLeft: Radius.circular(radius),
                      bottomRight: Radius.circular(radius),
                    ),
                  ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: (screenWidth * (2 / 3))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message,
                  style: byMe
                      ? Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: kWhite)
                      : Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              date,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          )
        ],
      ),
    );
  }
}

class DateLabel extends StatelessWidget {
  const DateLabel({super.key, required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: Card(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}

class _ActionBar extends StatefulWidget {
  const _ActionBar({super.key});

  @override
  State<_ActionBar> createState() => _ActionBarState();
}

class _ActionBarState extends State<_ActionBar> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: screenWidth),
      child: Container(
        color: Theme.of(context).cardColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton2(
                      onPressed: () {
                        print('Camera');
                      },
                      icon: CupertinoIcons.camera_fill),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 30,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 2.5),
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      child: TextField(
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type Something...',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: Theme.of(context).disabledColor)),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GlowingActionButton(
                      size: 30,
                      color: const Color(0xFF7BCBCF),
                      icon: Icons.send_rounded,
                      onPressed: () {
                        print('send');
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}