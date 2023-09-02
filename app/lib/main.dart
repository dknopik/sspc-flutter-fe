import 'package:app/screens/screen_account.dart';
import 'package:flutter/material.dart';

import 'package:app/services/database.dart';
import 'package:app/services/ethereum_connect.dart';
import 'package:app/services/walletconnect.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  final wallet = MyWallet();
  ChannelDB();
  WalletConnect();
  runApp(MyApp(init: wallet.initialization));
}

class MyApp extends StatelessWidget {
  Future<void> init;

  MyApp({super.key, required this.init});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Stupid Payment Channel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<void>(
        future: init,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AccountScreen();
          } else {
            return const Text("Loading...");
          }
        },
      )
    );
  }
}
