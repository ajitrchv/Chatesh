import 'package:chatesh/widgets/messages.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  // const MessageBubble({ Key? key }) : super(key: key);
  MessageBubble(this.message);
  final String message;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.amber[100],
          ),
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          //margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            message,
            style: message == '🚫Deleted Message'
                ? const TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey)
                : const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
