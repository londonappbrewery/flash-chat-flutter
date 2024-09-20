import 'package:meta/meta.dart';

@immutable
class MessageData {
  const MessageData(
      {required this.name,
      required this.message,
      required this.profilePicture,
      required this.messageDate,
      required this.dateMessage});
  final String name;
  final String message;
  final String profilePicture;
  final DateTime messageDate;
  final String dateMessage;
}
