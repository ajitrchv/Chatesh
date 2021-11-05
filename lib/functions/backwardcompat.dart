import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

getUserName(userid){

  return
  FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(userid).get(),
                      builder: (context, snapshot) {
                        
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const CircularProgressIndicator();
                        }
                        return Text(snapshot.data!['username']);
                      }
                    );

}