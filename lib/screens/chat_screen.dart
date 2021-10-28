import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  CollectionReference msgs = FirebaseFirestore.instance.collection('chats');

  List msgListMain = [];

  @override
  Widget build(BuildContext context) {
    List msgList = [];
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatesh"),
      ),
      body: StreamBuilder(
        stream: msgs.snapshots(),
        builder: (ctx, streamSnapshot) {
          if(streamSnapshot.connectionState == ConnectionState.waiting)
          {
            return const Center(child: CircularProgressIndicator());
          }
          else {
            return ListView.builder(
            itemCount: getcount(),
            itemBuilder: (ctx, i) => Container(
              padding: const EdgeInsets.all(10),
              child:  Text(
                msgListMain[i],
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            ),
          );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          //=================================

          //=================================

          fetchDBList();

          //print("$msgListMain======================================================the main item");
        },
      ),
    );
  }

  int getcount() {
    try {
      int counter = 0;
      msgListMain.forEach((element){
        counter++;
      });
        //print(counter);
        return counter;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future getMessage() async {
    List ls = [];
    var jdoc;
    var jdoc2;
    try {
      await msgs.get().then((qrySnapshot) {
        qrySnapshot.docs.forEach((element) {
          //print('${element.data()}=====================before encode');
          jdoc = json.encode(element.data());
          jdoc2 = json.decode(jdoc)["text"];
          //print('${jdoc2}=====================Json Encoded');
          ls.add(jdoc2);
        });
      });
      return ls;
    } catch (e) {
      print(e.toString());
      print('===================caught error============================');
      //return null;
    }
  }

  fetchDBList() async {
    var resultmsg = await getMessage();
    //print("${resultmsg}===================================fetchdb");
    if (resultmsg == null) {
      print("unable to get msg");
      //msgListMain.add('null');
      return resultmsg;
    } else {
      setState(() {
        msgListMain = resultmsg;
      });
    }
   
      //print(msgListMain);
   
  }
}
