
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {

getUserName(){
  return
  FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(usrinc).get(),
                      builder: (context, snapshot) {
                        
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const CircularProgressIndicator();
                        }
                        return Text(snapshot.data!['username'], style: 
                        TextStyle(
                          color: isMe ? Colors.blue : Colors.green,
                          fontSize: 15, 
                          fontStyle: FontStyle.italic, 
                          fontWeight: FontWeight.bold 
                          ), 
                          textAlign: isMe?TextAlign.end:TextAlign.start,);
                      }
                    );

}
  // const MessageBubble({ Key? key }) : super(key: key);
  MessageBubble(this.message, this.usrinc, this.username);
  final String message;
  var usrinc;
  var username;
  bool isMe= false;
  //final String username;
  //final Key key;
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    if(usrinc == user!.uid){
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(isMe)
                    const Text(' '),
                    Text(username, style: 
                        TextStyle(
                          color: isMe ? Colors.blue : Colors.green,
                          fontSize: 15, 
                          fontStyle: FontStyle.italic, 
                          fontWeight: FontWeight.bold 
                          ), 
                          textAlign: isMe?TextAlign.end:TextAlign.start,),
                    if(!isMe)
                    const Text(' '),
                  ],
                )
              ),
              Text(
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
                            textAlign: TextAlign.start,

              ),
            ],
          ),
        ),
      ],
    );
  }
}
