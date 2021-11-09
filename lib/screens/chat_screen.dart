

import 'package:chatesh/widgets/message_bubble.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../widgets/newmessage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core_web/firebase_core_web.dart';
// import '../functions/backwardcompat.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

class ChatScreen extends StatefulWidget {
  static const routeName = '/ChatScreen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void initState(){
    super.initState();
    final fbm = FirebaseMessaging.instance;
        fbm.subscribeToTopic('chats');



        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      Map<String, dynamic> data = message.data;
      notification = notification as RemoteNotification;
      print("_messaging onMessage: ${message}");
      //showNotification(notification.body, notification.title);
      String type = data['type'];
      if (type == "view") {
        String notifPath = data['subject'];
        //notificationProvider.addPath(notifPath);
        print('new notification added to notificationList: ${notifPath}');
      }
    });
        
   
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved on message");
      print(event.notification!.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      print("message recieved on message opened app");
      print(event.notification!.body);
  });

    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


 
   
  //   FirebaseMessaging.onMessage.listen((RemoteMessage event) {
  //     print("message recieved");
  //     print(event.notification!.body);
  // });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

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
            items: const [
              DropdownMenuItem(
                child: Text('Log Out'),
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
                    // print(document['text']);
                    // print(document['userID']);
                    // print(document['username']);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MessageBubble(
                        document['text'] == 'null' 
                        ? '🚫Deleted Message' 
                        : document['text'], 
                        document['userID'], 
                        document['username'],
                        document['userimage']
                        )
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
