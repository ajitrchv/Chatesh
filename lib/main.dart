// ignore_for_file: deprecated_member_use

import 'package:chatesh/screens/auth_screen.dart';
import 'package:chatesh/screens/chat_screen.dart';

import './widgets/auth.dart';


import 'package:flutter/material.dart';
 import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
    class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            return MaterialApp(
              title: 'Flutter Chat',
              theme: ThemeData(
                backgroundColor: Colors.pink,
                accentColorBrightness: Brightness.dark, colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(secondary: Colors.pink),
              ),
              home: AuthScreen(),
            );
          },
        );
      }
    }