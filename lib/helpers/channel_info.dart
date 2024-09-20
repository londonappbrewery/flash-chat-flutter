import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

String getChannelName(Channel channel, User currentUser) {
  if (channel.name != null && channel.name != '') {
    return channel.name!;
  } else {
    final otherMembers = channel.state!.members
        .where((e) => e.userId != currentUser.id)
        .toList();
    if (otherMembers.length == 1) {
      return otherMembers.first.user!.name;
    } else if (otherMembers.length > 1) {
      return otherMembers.map((e) => e.user!.name).join(', ');
    }
  }

  return '';
}

String getChannelImage(Channel channel, User currentUser) {
  if (channel.image != null && channel.image != '') {
    return channel.image!;
  } else {
    final otherMembers = channel.state!.members
        .where((e) => e.userId != currentUser.id)
        .toList();
    if (otherMembers.isEmpty) {
      return 'Me';
    } else if (otherMembers.length == 1) {
      return otherMembers.first.user!.image!;
    }
    return otherMembers.first.user!.image!;
  }
}

String getFormattedLastMessageAt(dynamic data) {
  final lastMessageAt = data.toLocal();
  String stringDate;
  final now = DateTime.now();

  final startOfDay = DateTime(now.year, now.month, now.day);

  if (lastMessageAt.millisecondsSinceEpoch >=
      startOfDay.millisecondsSinceEpoch) {
    stringDate = Jiffy.parseFromDateTime(lastMessageAt.toLocal()).jm;
  } else if (lastMessageAt.millisecondsSinceEpoch >=
      startOfDay.subtract(const Duration(days: 1)).millisecondsSinceEpoch) {
    stringDate = 'YESTERDAY';
  } else if (startOfDay.difference(lastMessageAt).inDays < 7) {
    stringDate = Jiffy.parseFromDateTime(lastMessageAt.toLocal()).EEEE;
  } else {
    stringDate = Jiffy.parseFromDateTime(lastMessageAt.toLocal()).yMd;
  }
  return stringDate;
}


