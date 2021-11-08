import 'dart:io';

import 'package:chatesh/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  static const routeName='/AuthScreen';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //var dbref = FirebaseFirestore.instance.collection('usernames');
  void showAlert(BuildContext context, String errmsg, String titmsg) {
showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(titmsg, style: const TextStyle(color: Colors.red),),
          content: Text(errmsg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
  }
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;
  Future<void> _submitAuthForm(String? email, String? password,
      String? username,File image, bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        
        authResult = await _auth.signInWithEmailAndPassword(
            email: email as String, password: password as String);
      } else {
            authResult = await _auth.createUserWithEmailAndPassword(
            email: email as String, password: password as String);
 
            //print(authResult);
            final ref2 = await FirebaseStorage.instance
            .ref('user_image')
            .child(authResult.user!.uid+'.jpg')
            .putFile(image)
            .then((takeSnapshot) => print('Task Done======================='));

            //ref2.putFile(image);

            ////print("imagge=========================");

            //final imgurl = await ref2.getDownloadURL();
            final imgurl = await FirebaseStorage.instance
              .ref('user_image')
              .child(authResult.user!.uid+'.jpg')
              .getDownloadURL()
              .then((imgurl) {
              //print("Here is the URL of Image $imgurl");
              return imgurl;
            }).catchError((onError) {
            //print("Got Error $onError");
            });
            
            //print(imgurl);

             Map<String, String> userCredInfo = 
                {
                  'username': username as String,
                  'email': email as String,
                  'password': password as String,
                  'image_url': imgurl,
                };
        var uid = authResult.user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set(userCredInfo);
        //await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set(userCredInfo);
      }

      print(authResult);
      if(authResult.toString().contains('AdditionalUserInfo')){
        Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
      }
      // ignore: nullable_type_in_catch_clause
    } on PlatformException catch (e) {
      setState(() {
        _isLoading =false;
      });

      var messageofPlatform = 'An error occured: Please check your credentials.';

      messageofPlatform = e.message!;
      Future.delayed(Duration.zero, () => showAlert(context,messageofPlatform,'Uh,oh!'));
      //showAlert(context, messageofPlatform,'Uh,oh!');
    } catch (e) {
      //  print('===========Error==============');
      //  print(e.toString());
      setState(() {
        _isLoading =false;
      });
      var contMessage = 'Welcome!';
      var titMessage = 'Uh,oh!';
      var ErrChk = false;
      if(e.toString().contains('user-not-found')){
        contMessage = 'Check your credentials!';
        titMessage = 'Credentials Error';
        ErrChk = true;
      }
      if(e.toString().contains('password is invalid')){
        contMessage = 'Please check your password and try again!';
        titMessage = 'Invalid Password';
        ErrChk = true;
      }
      if(e.toString().contains('The email address is badly formatted')){
        contMessage = 'Please check your email address and try again!';
        titMessage = 'Email Error';
        ErrChk = true;
      }
      if(e.toString().contains('address is already in use')){
        contMessage = 'This mail ID exists. Try again with another ID!';
        titMessage = 'Email Error';
        ErrChk = true;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(contMessage, style: TextStyle(color:Colors.white),), backgroundColor: ErrChk? Colors.red: Colors.blue,));
      //     tester1@test.com   1234567
      
      // showAlert(context,contMessage,titMessage);
      // Fluttertoast.showToast(
      //     msg: 'Uh,oh! Some error occured!',
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.pink, 
    body: Auth(_submitAuthForm, _isLoading));
  }
}
