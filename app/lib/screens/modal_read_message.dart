import 'dart:io';

import 'package:app/screens/modal_qr_scan.dart';
import 'package:app/services/ethereum_connect.dart';
import 'package:app/services/link.dart';
import 'package:app/services/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ModalReadMessage extends StatefulWidget {

  const ModalReadMessage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ModalReadMessageState();
}

class _ModalReadMessageState extends State<ModalReadMessage> {
  String? result;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            if (_isKeyboardVisible) SizedBox(height: 16),
            Column(
              children: [
                Container(
                  height: 50,
                  width: 130,
                  color: Colors.white,
                  child: TextField(
                    onChanged: (str) {
                      setState(() {
                        result = str;
                      });
                    },
                  ),
                ),
                Container(
                  height: 50,
                  width: 130,
                  color: Colors.blue,
                  child: GestureDetector(
                    child: Text('Scan QR Code'),
                    onTap: () async {
                      String? res = await showMaterialModalBottomSheet(
                        expand: false,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ModalPQRScan(),
                      );
                      setState(() {
                        result = res ?? '';
                      });
                    },
                  )
                ),
                Container(
                  height: 50,
                  width: 130,
                  color: Colors.green,
                  child: GestureDetector(
                    child: Text('Okay'),
                    onTap: () async {
                      Navigator.pop(context, result);
                    },
                  )
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
