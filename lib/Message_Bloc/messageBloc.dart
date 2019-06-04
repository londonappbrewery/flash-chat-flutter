import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'message.dart';

class MessagesBloc extends ChangeNotifier {
  Firestore firestore = Firestore.instance;
  List<Message> _messageModelList = [];
  bool isEmpty = true;

  List<Message> get messageModel => _messageModelList;

  // set messageModel(List<Message> messageModelList) {
  //   _messageModelList = messageModelList;
  //   notifyListeners();
  // }

  MessagesBloc() {
    getMessages();
  }

  getMessages() async {
    await for (var snapshot in firestore.collection("message").snapshots()) {
      if (snapshot != null) {
        isEmpty = false;
        for (var message in snapshot.documentChanges.reversed) {
          var newMessage = message.document;
          _messageModelList.add(Message(newMessage['sender'], newMessage['text']));
          notifyListeners();
        }
      }
      else {
        isEmpty = true;
        _messageModelList = null;
        notifyListeners();
      }
    }
  }
  
}

// class MessageListWidget extends StatelessWidget {

//   final List<Message> messageModelList;

//   MessageListWidget(this.messageModelList);

//   List<MessageBubble> messagesViewWidget = [];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: child,
//     );
//   }
// }

// class MessageBubble extends StatelessWidget {
//   final String text;
//   final String sender;
//   const MessageBubble({this.sender, this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(6),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: <Widget>[
//           Text(
//             sender,
//             style: TextStyle(
//               color: Colors.black26,
//             ),
//           ),
//           Material(
//             elevation: 5,
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20)),
//             color: Colors.lightBlueAccent,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Text(
//                 text,
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
