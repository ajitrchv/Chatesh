import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class Messages extends StatefulWidget {
  const Messages({ Key? key }) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  var msgs = FirebaseFirestore.instance.collection('chats').orderBy('timestamp', descending: true);
  var itemCount = 0;
  @override
  build(BuildContext context) async{
    return StreamBuilder(
      stream: msgs.snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            var chatDocs = streamSnapshot.data!.docs;


            print(chatDocs);
            return  Text(chatDocs.toString());
            //ListView.builder(itemCount: getCount(),itemBuilder: (ctx, index) =>
                //Text(chatDocs.toString())
                
                //);
          }
      }
      
    );
  }

  getCount() async {
    List ls = [];
    try {
      await msgs.get().then((qrySnapshot) {
        qrySnapshot.docs.forEach((element) {
          itemCount = itemCount + 1;
        });
      });

      return itemCount;
    } catch (e) {
      print(e.toString());
      // print('===================caught error============================');
      //return null;
    }
  }
   void messageStream() async {
    await for (final snapshot
        in FirebaseFirestore.instance.collection('chats').snapshots()) {
      for (var message in snapshot.docs) {
        print('========================message stream======================================================');
        print(message.data()['text']);
      }
    }
  }
}

