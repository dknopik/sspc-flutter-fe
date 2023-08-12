import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ModalPropose extends StatefulWidget {
  final bool sending;
  final int prevA;
  final int prevB;

  const ModalPropose({
    super.key,
    required this.sending,
    required this.prevA,
    required this.prevB,
  });

  @override
  State<StatefulWidget> createState() => _ModalProposeState();
}

class _ModalProposeState extends State<ModalPropose> {
  int money = 10;
  final _controller = TextEditingController();
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
    _controller.dispose();

    super.dispose();
  }

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
            if (_isKeyboardVisible) SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 25,
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "XX",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child:
                  Text(widget.sending ? "Amount to send" : "Amount to request"),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: InkWell(
                      onTap: () {
                        if (money != 0) {
                          setState(() {
                            money -= 1;
                          });
                        }
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        radius: 20,
                        backgroundColor: Colors.grey,
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: TextField(
                    onChanged: (str) {
                      setState(() {
                        money = int.tryParse(_controller.text) ?? 0;
                      });
                    },
                    controller: _controller,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                      signed: true,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ], //// Only numbers can be entered
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          money += 1;
                        });
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        radius: 20,
                        backgroundColor: Colors.grey,
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(widget.sending
                  ? "New State: A ${widget.prevA + money} <-> B ${widget.prevB - money}"
                  : "New State: A ${widget.prevA - money} <-> B ${widget.prevB + money}"),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0x60282e),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "propose transaction",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0x60282e),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "cancel",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
