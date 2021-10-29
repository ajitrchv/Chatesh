import 'package:chatesh/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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

  final _auth = FirebaseAuth.instance;
  Future<void> _submitAuthForm(String? email, String? password,
      String? username, bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    try {
      if (isLogin) {
        //   print('=====================================');
        // print(email);
        // print('=====================================');
        // print(password);
        //   print('=====================================');
        authResult = await _auth.signInWithEmailAndPassword(
            email: email as String, password: password as String);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email as String, password: password as String);
      }
      print(authResult);
      if(authResult.toString().contains('AdditionalUserInfo')){
        Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
      }
      // ignore: nullable_type_in_catch_clause
    } on PlatformException catch (e) {

      var messageofPlatform = 'An error occured: Please check your credentials.';

      messageofPlatform = e.message!;
      Future.delayed(Duration.zero, () => showAlert(context,messageofPlatform,'Uh,oh!'));
      showAlert(context, messageofPlatform,'Uh,oh!');
    } catch (e) {
      var contMessage = 'Please check your credentials and try again!';
      var titMessage = 'Uh,oh!';
      if(e.toString().contains('The email address is badly formatted')){
        contMessage = 'Please check your email address and try again!';
        titMessage = 'Email Error';
      }
      if(e.toString().contains('password is invalid')){
        contMessage = 'Please check your password and try again!';
        titMessage = 'Invalid Password';
      }

      
      showAlert(context,contMessage,titMessage);
      Fluttertoast.showToast(
          msg: 'Uh,oh! Some error occured!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.pink, body: Auth(_submitAuthForm));
  }
}
