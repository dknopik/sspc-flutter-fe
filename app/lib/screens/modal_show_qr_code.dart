import 'package:app/services/ethereum_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ModalQR extends StatefulWidget {
  final Widget builder;
  final String data;

  const ModalQR({
    super.key,
    required this.builder,
    required this.data,
  });

  @override
  State<StatefulWidget> createState() => _ModalQRState();
}

class _ModalQRState extends State<ModalQR> {
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
            Center(
              child: SizedBox(
                width: 200,
                child: widget.builder,
              ),
            ),
            Center(
              child: GestureDetector(
                child: Text(widget.data),
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: widget.data));
                },
              )
            )
          ],
        ),
      ),
    );
  }
}
