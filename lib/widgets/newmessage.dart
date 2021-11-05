import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../functions/backwardcompat.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  CollectionReference msgs = FirebaseFirestore.instance.collection('chats');

  var _enteredMessage = '';
  final _controller = new TextEditingController();



  void _sendMessage() async{
    FocusScope.of(context).unfocus();
    final user =  FirebaseAuth.instance.currentUser;
    final userdata = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    // print('=====USERNAME>>==========');
    // print(user);
        Map<String, dynamic> messageSet = 
               {
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'userID': user.uid,
        'username': userdata['username'],
        
      };
    FirebaseFirestore.instance.collection('chats').add(messageSet);
    _controller.clear();

    

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Send a message...'
                ),
                onChanged: (value){
                    setState(() {
                      _enteredMessage = value;
                    });
                },
            ),
          ),
          IconButton(
          onPressed: _enteredMessage.trim().isEmpty? null 
          :
          _sendMessage, 
          icon: const Icon(Icons.send), 
          color: Theme.of(context).primaryColor,)
        ],
      ),
    );
  }
}
