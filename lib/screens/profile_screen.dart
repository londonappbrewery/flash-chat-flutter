import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/theme.dart';
import 'package:flash_chat/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = fa.FirebaseAuth.instance;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          progressIndicator: SpinKitChasingDots(
            color: Theme.of(context).primaryColor,
          ),
          inAsyncCall: _loading,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Avatar(
                          radius: 100,
                          imageUrl: context.userImage!,
                        ),
                        Text(
                          context.user!.extraData['name'].toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          context.user!.extraData['email'].toString(),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Column(
                      children: [
                        _PButton(
                          onPressed: () async {
                            await showMyDialog(context);
                          },
                          icon: Icons.logout,
                          text: 'Log Out',
                        ),
                        _PButton(
                          onPressed: () async {
                            try {
                              showDeleteDialog();
                            } catch (e) {
                              logger.e('Error deleting user: $e');
                            }
                          },
                          icon: Icons.heart_broken,
                          text: 'Delete',
                        ),
                      ],
                    );
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showDeleteDialog() {
    String password = '';
    late String provider;
    for (final providerData in _auth.currentUser!.providerData) {
      if (providerData.providerId == 'password') {
        provider = 'password';
      } else if (providerData.providerId == 'google.com') {
        provider = 'google.com';
      }
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text('Delete Account',
              style: Theme.of(context).textTheme.titleMedium),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  provider == 'password'
                      ? 'Please Enter your password to proceed with the deletion'
                      : 'Clicking the button will take you to google to reauthenticate and then delete your account.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                provider == 'password'
                    ? TextField(
                        obscureText: true,
                        onChanged: (value) {
                          password = value;
                          //Do something with the user input.
                        },
                        style: Theme.of(context).textTheme.bodyLarge,
                        cursorColor:
                            Theme.of(context).primaryColorDark.withOpacity(0.6),
                        decoration: getInputDecor('Enter your password'),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColor, fontSize: 14),
                )),
            TextButton(
                onPressed: () async {
                  try {
                    StreamChatCore.of(context).client.updateUser(
                            User(id: context.user!.id, extraData: const {
                          'deleted': true,
                        }));
                    if (provider == 'password') {
                      await _auth.currentUser!.reauthenticateWithCredential(
                          fa.EmailAuthProvider.credential(
                              email: _auth.currentUser!.email!,
                              password: password));
                    } else if (provider == 'google.com') {
                      await _auth.currentUser!
                          .reauthenticateWithProvider(fa.GoogleAuthProvider());
                    }
                  } catch (e) {
                    logger.e('Error reauthenticating user: $e');
                  }
                  StreamChatCore.of(context).client.disconnectUser();
                  await _auth.currentUser!.delete();
                  logger.i('Stream user deleted');
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                },
                child: Text(
                  'Proceed',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.errorColor, fontSize: 14),
                ))
          ],
        );
      },
    );
  }
}

class _PButton extends StatelessWidget {
  const _PButton(
      {required this.onPressed,
      required this.icon,
      this.iconColor = AppColors.textFaded,
      required this.text});
  final VoidCallback onPressed;
  final IconData icon;
  final Color? iconColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: iconColor?.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColorDark,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> logout() async {
  // Revoke Stream user token.
  final auth = fa.FirebaseAuth.instance;
  final functions = FirebaseFunctions.instance;

  final callable = functions.httpsCallable('revokeStreamUserToken');
  await callable();
  logger.i('Stream user token revoked');

  // Sign out Firebase.
  await auth.signOut();
  logger.i('Firebase signed out');
}

Future<void> showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Log Out', style: Theme.of(context).textTheme.titleMedium),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you Sure you want to log out ?',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColor, fontSize: 14),
              )),
          TextButton(
              onPressed: () async {
                StreamChatCore.of(context).client.disconnectUser();
                await logout();
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              },
              child: Text(
                'Yes',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColor, fontSize: 14),
              ))
        ],
      );
    },
  );
}
