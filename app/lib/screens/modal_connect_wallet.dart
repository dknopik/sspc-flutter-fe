import 'dart:io';

import 'package:app/services/walletconnect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModalWalletConnect extends StatefulWidget {
  ModalWalletConnect({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ModalWalletConnect();
}

class _ModalWalletConnect extends State<ModalWalletConnect> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            W3MNetworkSelectButton(service: WalletConnect._w3mService),
            W3MConnectWalletButton(service: WalletConnect._w3mService),
        ],
      ),
    );
  }
}
