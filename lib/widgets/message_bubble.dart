
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  // const MessageBubble({ Key? key }) : super(key: key);
  MessageBubble(this.message, this.uid,);
  final String message;
  var uid;
  bool isMe= false;
  //final Key key;
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    if(uid == user!.uid){
      isMe = true;
    }
    return Row(
      mainAxisAlignment: isMe? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.only
              (
                topLeft: Radius.circular(isMe ? 30 : 0),
                topRight: Radius.circular(isMe ? 0 : 30),
                bottomLeft: const Radius.circular(30),
                bottomRight: const Radius.circular(30),
              ),
            color: isMe?Colors.blue[100]: Colors.green[100],
          ),
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          //margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            message,
            style: message == '🚫Deleted Message'
                ? const TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey)
                : const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
          ),
        ),
      ],
    );
  }
}
