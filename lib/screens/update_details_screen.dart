import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/theme.dart';
import 'package:flash_chat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    as stream_chat;

class UpdateDetailsScreen extends StatefulWidget {
  const UpdateDetailsScreen({super.key});

  @override
  State<UpdateDetailsScreen> createState() => _UpdateDetailsScreenState();
}

class _UpdateDetailsScreenState extends State<UpdateDetailsScreen> {
  String name = '';
  String imageUrl = genericUrl;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final _functions = FirebaseFunctions.instance;
  String errorMessage = '';
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: SpinKitChasingDots(
        color: Theme.of(context).primaryColor,
      ),
      inAsyncCall: _loading,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: PopupMenuButton<ImageSource>(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            icon: imageUrl == genericUrl
                                ? const Icon(
                                    Icons.add_a_photo,
                                    color: AppColors.textLight,
                                    size: 50,
                                  )
                                : null,
                            child: imageUrl == genericUrl
                                ? null
                                : Avatar(radius: 50, imageUrl: imageUrl),
                            onSelected: (ImageSource result) async {
                              ImagePicker imagePicker = ImagePicker();
                              XFile? file;
                              try {
                                file =
                                    await imagePicker.pickImage(source: result);
                              } catch (e) {
                                print(e);
                              }
                              ;
                              if (file != null) {
                                Reference ref = _storage
                                    .ref()
                                    .child('profile_pictures')
                                    .child(_auth.currentUser!.email!);
                                try {
                                  setState(() {
                                    _loading = true;
                                  });
                                  await ref.putFile(File(file.path));
                                  imageUrl = await ref.getDownloadURL();
                                  setState(() {
                                    _loading = false;
                                    imageUrl = imageUrl;
                                  });
                                } catch (e) {
                                  print(e);
                                  setState(() {
                                    _loading = false;
                                    imageUrl = genericUrl;
                                  });
                                }
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<ImageSource>>[
                                  PopupMenuItem<ImageSource>(
                                    value: ImageSource.gallery,
                                    child: Text(
                                      'Gallery',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                  PopupMenuItem<ImageSource>(
                                    value: ImageSource.camera,
                                    child: Text('Camera',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                  ),
                                ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                          onChanged: (value) {
                            name = value;
                            //Do something with the user input.
                          },
                          style: Theme.of(context).textTheme.bodyLarge,
                          cursorColor: Theme.of(context)
                              .primaryColorDark
                              .withOpacity(0.6),
                          decoration: getInputDecor('Enter your Display Name')),
                    ),
                    Text(errorMessage,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.errorColor)),
                  ],
                ),
                getButton('Next', onPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  if (name.isEmpty) {
                    setState(() {
                      _loading = false;
                      errorMessage = 'Name cannot be empty';
                    });
                  } else {
                    await _auth.currentUser?.updateDisplayName(name);
                    await _auth.currentUser?.updatePhotoURL(imageUrl);
                    final callable =
                        _functions.httpsCallable('createStreamUserAndGetToken');
                    final results = await callable();
                    final token = results.data;
                    final client =
                        stream_chat.StreamChatCore.of(context).client;
                    client.connectUser(
                        stream_chat.User(
                          id: _auth.currentUser!.uid,
                          extraData: {
                            'name': _auth.currentUser!.displayName,
                            'email': _auth.currentUser!.email,
                            'deleted': false,
                          },
                          image: _auth.currentUser!.photoURL,
                        ),
                        token);
                    Navigator.pushNamed(context, '/home');
                  }
                }, context: context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
