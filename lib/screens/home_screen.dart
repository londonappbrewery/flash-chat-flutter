import 'package:flash_chat/screens/home_pages/messages.dart';
import 'package:flash_chat/screens/home_pages/contacts.dart';
import 'package:flash_chat/screens/home_pages/calls.dart';
import 'package:flash_chat/screens/home_pages/notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    as stream_chat;
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pages = const [
    MessageScreen(),
    NotificationScreen(),
    ContactScreen(),
    CallScreen(),
  ];
  final pageNames = const [
    'Messages',
    'Notifications',
    'Contacts',
    'Calls',
  ];

  ValueNotifier<int> pageIndex = ValueNotifier(0);
  late final stream_chat.StreamChatClient client;
  @override
  initState() {
    super.initState();
    client = stream_chat.StreamChatCore.of(context).client;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          scrolledUnderElevation: 1,
          elevation: 0,
          leading: Align(
            alignment: Alignment.centerRight,
            child: IconButton2(
              icon: CupertinoIcons.search,
              onPressed: () {
                logger.i('Search button pressed');
              },
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Avatar.small(
                imageUrl: context.user!.image!,
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            )
          ],
          title: ValueListenableBuilder<int>(
            valueListenable: pageIndex,
            builder: (BuildContext context, int index, _) {
              return index != 4
                  ? Text(
                      pageNames[index].toString(),
                      style: kHeadingStyle1(
                          fontSize: 20,
                          color: Theme.of(context).primaryColorDark),
                    )
                  : Text(
                      pageNames[0].toString(),
                      style: kHeadingStyle1(
                          fontSize: 20,
                          color: Theme.of(context).primaryColorDark),
                    );
            },
          ),
        ),
        body: ValueListenableBuilder<int>(
          valueListenable: pageIndex,
          builder: (BuildContext context, int index, _) {
            return index != 4 ? pages[index] : pages[0];
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          itemChanged: (index) {
            setState(() {
              pageIndex.value = index;
            });
          },
        ),
      ),
    );
  }
}

class BottomNavigationBar extends StatefulWidget {
  const BottomNavigationBar({super.key, required this.itemChanged});
  final ValueChanged<int> itemChanged;

  @override
  State<BottomNavigationBar> createState() => BottomNavigationBarState();
}

class BottomNavigationBarState extends State<BottomNavigationBar> {
  int currentindex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: SafeArea(
        top: false,
        bottom: true,
        child: Container(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavbarItem(
                  0,
                  icon: CupertinoIcons.chat_bubble_2_fill,
                  isSelected: currentindex == 0,
                  label: 'Messages',
                  onTap: (index) {
                    setState(() {
                      currentindex = index;
                      widget.itemChanged(index);
                    });
                  },
                ),
                NavbarItem(3,
                    icon: CupertinoIcons.phone_fill,
                    label: 'Calls',
                    isSelected: currentindex == 3, onTap: (index) {
                  setState(() {
                    currentindex = index;
                    widget.itemChanged(index);
                  });
                }),
                GlowingActionButton(
                    color: Theme.of(context).primaryColor,
                    size: 40,
                    onPressed: () {},
                    icon: CupertinoIcons.add),
                NavbarItem(2,
                    icon: CupertinoIcons.person_2_fill,
                    label: 'Contacts',
                    isSelected: currentindex == 2, onTap: (index) {
                  setState(() {
                    currentindex = index;
                    widget.itemChanged(index);
                  });
                }),
                NavbarItem(1,
                    icon: CupertinoIcons.bell_fill,
                    label: 'Notifications',
                    isSelected: currentindex == 1, onTap: (index) {
                  setState(() {
                    currentindex = index;
                    widget.itemChanged(index);
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavbarItem extends StatefulWidget {
  NavbarItem(this.index,
      {super.key,
      required this.icon,
      required this.label,
      required this.onTap,
      this.isSelected = false});
  final IconData icon;
  final String label;
  final int index;
  bool isSelected;
  final ValueChanged<int> onTap;
  @override
  State<NavbarItem> createState() => _NavbarItemState();
}

class _NavbarItemState extends State<NavbarItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.onTap(widget.index);
      },
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: widget.isSelected ? 18 : 16,
              color: widget.isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).iconTheme.color,
            ),
            const SizedBox(height: 4),
            Text(widget.label,
                style: widget.isSelected
                    ? Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 11,
                        color: Theme.of(context).primaryColor,
                        letterSpacing: 0.5)
                    : Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 10))
          ],
        ),
      ),
    );
  }
}
