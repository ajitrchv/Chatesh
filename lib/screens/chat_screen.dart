// ignore_for_file: avoid_print

import 'package:chatesh/widgets/message_bubble.dart';

import '../widgets/newmessage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/messages.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/ChatScreen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  CollectionReference msgs = FirebaseFirestore.instance.collection('chats');

  var msgListMain = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatesh"),
        actions: [
          DropdownButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: const [
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Log Out')
                  ],
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemID) {
              if (itemID == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  //checkMessage();
                  return const Center(child: CircularProgressIndicator());
                } else {
                  List<DocumentSnapshot> doc = streamSnapshot.data.docs;
                  var a = doc.map((document) {
                    //print("${(document.contains('')).toString()}===");
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MessageBubble(document['text'] == 'null' ? '🚫Deleted Message' : document['text'])
                    );
                  }).toList();
                  return ListView(
                    reverse: true,
                    children: [
                      ...a,
                    ],
                  );
                }
              },
            ),
          ),
          const NewMessage()
        ],
      ),
    );
  }
}
