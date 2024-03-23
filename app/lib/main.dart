import 'package:app/screens/screen_account.dart';
import 'package:flutter/material.dart';

import 'package:app/services/database.dart';
import 'package:app/services/ethereum_connect.dart';
import 'package:app/services/walletconnect.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Stupid Payment Channel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AccountScreen()
    );
  }
}
