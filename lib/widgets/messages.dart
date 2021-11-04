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
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chats').orderBy('createdAt', descending: true).snapshots(),
        builder: (ctx, AsyncSnapshot streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              List<DocumentSnapshot> doc = streamSnapshot.data.docs;
                    var a  = doc.map((document) {
                      //print("${(document.contains('')).toString()}===");
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(document['text'].toString() == 'null' ?
                       '🚫Deleted message'
                       : (document['text']),style: document['text'].toString() == 'null' ?
                      const TextStyle(
                                    fontSize: 25,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey)
                       : const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),),
                    );
                    }).toList();
                    return ListView(
                      reverse: true,
                      children: [
                        ...a,
                    ],);
            }
        }
        
      ),
    );
  }
}

