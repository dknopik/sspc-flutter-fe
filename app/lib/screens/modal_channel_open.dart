import 'package:app/services/ethereum_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ModalChannelOpen extends StatefulWidget {
  final MyWallet myWallet;

  const ModalChannelOpen({
    super.key,
    required this.myWallet,
  });

  @override
  State<StatefulWidget> createState() => _ModalChannelOpenState();
}

class _ModalChannelOpenState extends State<ModalChannelOpen> {
  int a = 0;
  int b = 0;
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
              // TODO no need for A B state when openning channel?
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Initiator: '),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  width: 130,
                  child: TextField(
                    onChanged: (str) {
                      setState(() {
                        a = int.tryParse(_controllerA.text) ?? 0;
                      });
                    },
                    controller: _controllerA,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                      signed: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'initial eth',
                      // border: OutlineInputBorder(),
                      fillColor: Color(0xFF565559),
                      floatingLabelStyle: TextStyle(color: Color(0xFF565559)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF565559), width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),

                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Responder: '),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  width: 130,
                  child: TextField(
                    onChanged: (str) {
                      setState(() {
                        b = int.tryParse(_controllerB.text) ?? 0;
                      });
                    },
                    controller: _controllerB,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                      signed: true,
                    ),
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(color: Color(0xFF565559)),
                      labelText: 'initial eth',
                      fillColor: Color(0xFF565559),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF565559), width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      // border: OutlineInputBorder(),
                    ),

                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                  ),
                ),
              ],
            ),

            //only as placeholder
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text('Opponent Address'),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: TextField(
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(color: Color(0xFF565559)),
                      labelText: 'enter the address of opponent party',
                      fillColor: Color(0xFF565559),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF565559), width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      // border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () async {
                  //todo Function Open Channel
                  Navigator.pop(context);
                  ChannelObj obj = widget.myWallet.createNewChannel();
                  String other = "0x001234";
                  BigInt id =
                      await obj.open(other, BigInt.from(a), BigInt.from(b));
                  //widget.myNetwork.Send(id, )
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [],
                    border: Border.all(
                      color: Color(0xFF565559),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "Propose transaction",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
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
