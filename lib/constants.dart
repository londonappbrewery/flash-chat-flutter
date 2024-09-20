import 'package:flutter/material.dart';

import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:logger/logger.dart' as log;
import 'theme.dart';

const kBlueBody = Color(0x90002DE3);
const kBlue2 = Color(0xFF002DE3);
const kDarkThemeBlue = Color(0xFF879FFF);
const kWhite = Color(0xFFF7F7F7);
const kCardColor = Color(0xFF1B2B48);
const kBackgroundColor = Color(0xFF152033);
const kGreen = Color(0xFF2CC069);
const streamApi = 'chvdm4sex6zq';
final logger = log.Logger();
const genericUrl =
    'https://firebasestorage.googleapis.com/v0/b/chateo-72766.appspot.com/o/profile_pictures%2FGeneric%20Image.png?alt=media&token=995355af-474e-40e8-8f43-daff2ff93918';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

TextStyle kHeadingStyle1(
    {double fontSize = 32.0, Color color = const Color(0xFF0F1828)}) {
  return TextStyle(
    color: color,
    fontFamily: 'Mulish',
    fontSize: fontSize,
    fontWeight: FontWeight.w900,
    fontVariations: const [FontVariation('wght', 900)],
  );
}

TextStyle kHeadingStyle2(
    {double fontSize = 24.0, Color color = const Color(0xFF0F1828)}) {
  return TextStyle(
    color: color,
    fontFamily: 'Mulish',
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    fontVariations: const [FontVariation('wght', 900)],
  );
}

TextStyle kSubheadingStyle1(
    {double fontSize = 18.0, Color color = const Color(0xFF0F1828)}) {
  return TextStyle(
    color: color,
    fontFamily: 'Mulish',
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    fontVariations: const [FontVariation('wght', 700)],
  );
}

TextStyle kSubheadingStyle2(
    {double fontSize = 16.0, Color color = const Color(0xFF0F1828)}) {
  return TextStyle(
    color: color,
    fontFamily: 'Mulish',
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    fontVariations: const [FontVariation('wght', 700)],
  );
}

TextStyle kBodyStyle1(
    {double fontSize = 14.0, Color color = const Color(0xFF0F1828)}) {
  return TextStyle(
    color: color,
    fontFamily: 'Mulish',
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    fontVariations: const [FontVariation('wght', 700)],
  );
}

TextStyle kBodyStyle2(
    {double fontSize = 14.0, Color color = const Color(0xFF0F1828)}) {
  return TextStyle(
    color: color,
    fontFamily: 'Mulish',
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
    fontVariations: const [FontVariation('wght', 600)],
  );
}

TextStyle kMetadataStyle1(
    {double fontSize = 12.0, Color color = const Color(0xFF0F1828)}) {
  return TextStyle(
    color: color,
    fontFamily: 'Mulish',
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
    fontVariations: const [FontVariation('wght', 600)],
  );
}

TextStyle kErrorStyle1(
    {double fontSize = 12.0,
    Color color = const Color.fromARGB(255, 156, 51, 51)}) {
  return TextStyle(
    color: color,
    fontFamily: 'Mulish',
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
    fontVariations: const [FontVariation('wght', 600)],
  );
}

TextStyle kMetadataStyle2(
    {double fontSize = 10.0, Color color = const Color(0xFF0F1828)}) {
  return TextStyle(
    color: color,
    fontFamily: 'Mulish',
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
    fontVariations: const [FontVariation('wght', 600)],
  );
}

TextStyle kMetadataStyle3(
    {double fontSize = 10.0, Color color = const Color(0xFF0F1828)}) {
  return TextStyle(
    color: color,
    fontFamily: 'Mulish',
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    fontVariations: const [FontVariation('wght', 700)],
  );
}

InputDecoration getInputDecor(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: kBodyStyle1(color: const Color(0xFFADB5BD)),
    fillColor: Colors.grey.withOpacity(0.1),
    filled: true,
    contentPadding:
        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    ),
  );
}

Widget getButton(String text,
    {required VoidCallback onPressed, required BuildContext context}) {
  return Material(
    color: Theme.of(context).primaryColor,
    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
    elevation: 1.0,
    child: InkWell(
      splashColor: Theme.of(context).primaryColorDark,
      child: MaterialButton(
        onPressed: () {
          onPressed();
        },
        minWidth: 200.0,
        height: 42.0,
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Colors.white),
        ),
      ),
    ),
  );
}

Widget getImageButton(
  String text, {
  required VoidCallback onPressed,
  required BuildContext context,
  required String image,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Material(
      color: Theme.of(context).primaryColor,
      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
      elevation: 1.0,
      child: InkWell(
        splashColor: Theme.of(context).primaryColorDark,
        child: MaterialButton(
          onPressed: () {
            onPressed();
          },
          minWidth: 200.0,
          height: 42.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset('images/' + image),
              Image(
                image: AssetImage('images/' + image),
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 8.0),
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

extension StreamChatContext on BuildContext {
  /// Fetches the current user image.
  String? get userImage => user!.image;

  /// Fetches the current user.
  User? get user => StreamChatCore.of(this).currentUser;
}
