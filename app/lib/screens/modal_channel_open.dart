import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ModalChannelOpen extends StatefulWidget {
  const ModalChannelOpen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ModalChannelOpenState();
}

class _ModalChannelOpenState extends State<ModalChannelOpen> {
  double a = 0;
  double b = 0;
  final _controllerA = TextEditingController();
  final _controllerB = TextEditingController();
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
    _controllerA.dispose();
    _controllerB.dispose();
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
            Row(
              children: [
                Text('A: '),
                Container(
                  height: 100,
                  width: 300,
                  child: TextField(
                    onChanged: (str) {
                      setState(() {
                        a = double.tryParse(_controllerA.text) ?? 0.0;
                      });
                    },
                    controller: _controllerA,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Enter a Double Number',
                      border: OutlineInputBorder(),
                    ),

                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}$')),
                    ], // Only numbers can be entered
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('B: '),
                Container(
                  height: 100,
                  width: 300,
                  child: TextField(
                    onChanged: (str) {
                      setState(() {
                        b = double.tryParse(_controllerB.text) ?? 0.0;
                      });
                    },
                    controller: _controllerB,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Enter a Double Number',
                      border: OutlineInputBorder(),
                    ),

                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}$')),
                    ], // Only numbers can be entered
                  ),
                ),
              ],
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
            )
          ],
        ),
      ),
    );
  }
}
