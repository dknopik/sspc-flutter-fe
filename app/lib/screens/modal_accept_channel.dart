import 'package:app/services/ethereum_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

class ModalAcceptChannel extends StatelessWidget {
  final Uint8List id;
  final BigInt otherBal;
  final BigInt myBal;
  final Uint8List other;

  ModalAcceptChannel({required this.id, required this.otherBal, required this.myBal, required this.other});

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
          children: <Widget>[
            Text('Do you want to accept this channel opening?'),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  print(other);
                  ChannelObj channel = MyWallet().createNewChannel();
                  EthereumAddress otherAddr = EthereumAddress(other);
                  channel.accept(id, otherAddr, myBal, otherBal);
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
                        "accept the channel",
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
                        "Cancel",
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
