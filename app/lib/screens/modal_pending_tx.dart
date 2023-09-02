
import 'package:flutter/material.dart';

class ModalPendingTx<T> extends StatefulWidget {
  final Future<T> tx;

  ModalPendingTx({
    super.key,
    required this.tx
  });

  @override
  State<StatefulWidget> createState() => _ModalPendingTxState<T>();
}

class _ModalPendingTxState<T> extends State<ModalPendingTx<T>> {

  @override
  void initState() {
    super.initState();
    widget.tx.then((value) {
      Navigator.of(context).pop(value);
    }, onError: (error) {
      print(error);
      Navigator.of(context).pop(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20))),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: 200,
                  child: Text("Sending transaction..."),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}