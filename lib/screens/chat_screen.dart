import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';

class ChatScreen extends StatefulWidget {
  static const routeName = '/ChatScreen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  CollectionReference msgs = FirebaseFirestore.instance.collection('chats');

  List msgListMain = [];

  int count = 0;
  var i=0;
  vs()async{
    await fetchDBList();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context){
    if(i==0){
      vs();
      i=1;
    }
    

    List msgList = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatesh"),
      ),
      body: StreamBuilder(
        stream: msgs.snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: getcount(),
              itemBuilder: (ctx, i) => Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  msgListMain[i],
                  style:  msgListMain[i]=='🚫Deleted message' ?  const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey) : const TextStyle(
                      // fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
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
          count++;
          //=================================

          msgs.add({
            'text': 'Clicked button $count times to add the message num:$count'
          });

         vs();

          //print("$msgListMain======================================================the main item");
        },
      ),
    );
    
  }

  int getcount() {
    try {
      int counter = 0;
      msgListMain.forEach((element) {
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
          
          jdoc = element.data();
          //print('${jdoc['text']}=====================element');
          if(jdoc['text']!=null){
           ls.add(jdoc['text']);
          }
          else{
            ls.add('🚫Deleted message');
          }
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
      msgListMain = resultmsg;
    }

    //print(msgListMain);
  }
}
