import 'dart:io';

import 'package:app/services/ethereum_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ModalDispute extends StatefulWidget {
  ModalDispute({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ModalDispute();
}

class _ModalDispute extends State<ModalDispute> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Wrap(
          children: <Widget>[
          ],
        ),
      ),
    );
  }
}
