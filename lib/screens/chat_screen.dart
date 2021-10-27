import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  CollectionReference msgs = FirebaseFirestore.instance
      .collection('chats');

  List msgListMain = [];

  @override
  Widget build(BuildContext context) {
    List msgList = [];
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatesh"),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) => Container(
          padding: const EdgeInsets.all(10),
          child: const Text(
            "Hi Chatesh!",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          //=================================

          //=================================
          
          fetchDBList();
          
          print("$msgListMain======================================================the main item");
        },
      ),
    );
  }

  Future getMessage() async {
    List ls = [];
    var jdoc;
    try {
      await msgs.get().then((qrySnapshot) {
        qrySnapshot.docs.forEach((element) {
          print('${element.data()}=====================before encode');
          jdoc = json.encode(element.data());
          print('${element.data()}=====================Json Encoded');
          ls.add(jdoc);
        });
      });
      return ls;
    } catch (e) {
      print("${e.toString()}=================================");
      print('===================cactch============================');
      //return null;
    }
  }

  fetchDBList() async {
    dynamic resultmsg = await getMessage();
    print("$resultmsg===========================================================fetchdb");
    if (resultmsg == null) {
      print("unable to get msg");
    } else {
      setState(() {
         msgListMain = resultmsg;
         print("$msgListMain================the main in=========fetchdb");
      });
     }
  }
}





//         FutureBuilder<DocumentSnapshot>(
          //           future: msgs.doc().get(),
          //           builder:
          //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          //       if (snapshot.hasError) {
          //         return Text("Something went wrong");
          //       }

          //       if (snapshot.hasData && !snapshot.data!.exists) {
          //         return Text("Document does not exist");
          //       }
          //       if (snapshot.connectionState == ConnectionState.done) {
          //         Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          //         //Center(child: Text("Full Name: ${data['full_name']} ${data['last_name']}"));
          //         Center(child: Text("${data['text']}"));
          //         if (snapshot.connectionState == ConnectionState.done) {
          //         Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          //         return Text("Full Name: ${data['full_name']} ${data['last_name']}");
          //       }

          //       }
          //         });

          //   print("inside onpressed Floating============================================================");
          //   Firebase.initializeApp();
          //   FirebaseFirestore.instance
          //       .collection('chats/Je4VNAYCG8T9FwtRgu1Z/messages')
          //       .snapshots()
          //       .listen(
          //     (data) {
          //       print("inside listen data============================================================");

          //       data.docs.forEach((element) {
          //         print("inside foreach============================================================");

          //         print(element.data()['text']);

          //         print("inside after text===========================================================");

          //       });
          //     },
          //   );