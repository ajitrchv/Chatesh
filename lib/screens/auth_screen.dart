import 'package:flutter/material.dart';
import '../widgets/auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

void _submitAuthForm(
    String? email, String? password, String? username, bool isLogin) {

    }

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.pink, body: Auth(_submitAuthForm));
  }
}
