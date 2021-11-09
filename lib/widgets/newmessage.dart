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
   final user =  FirebaseAuth.instance.currentUser;


  void _sendMessage() async{
    FocusScope.of(context).unfocus();
    final x = user!.uid;
    
    final userdata = await FirebaseFirestore.instance.collection('users').doc(x).get();
    //final userdata = await FirebaseFirestore.instance.collection('users');
    //=================================================================================
    //
    //        HERE PROBLEM IS FROMM AUTHSCREEN
    //         NOT ALLOWING USER DATA TO PASS TO DB
    //=================================================================================
    //print('userID');
    //print(x);
     //print('=====USER>>==========');
    //print(userdata.data().toString().contains('username') ? userdata.get('username') : 'none username found');
     //print(userdata.data());
     //print("======seperator");
     //print(user);
     //print('^^^^^^user^^^^^^^^^');
        Map<String, dynamic> messageSet = 
               {
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'userID': user!.uid,
        'username': userdata['username'],
        'userimage': userdata['image_url'],
      };
    await FirebaseFirestore.instance.collection('chats').add(messageSet);
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
