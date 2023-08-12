import 'package:app/screens/screen_account.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Stupid Payment Channel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AccountScreen(),
    );
  }
}
