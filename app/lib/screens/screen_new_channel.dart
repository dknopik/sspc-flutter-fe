import 'dart:async';

import 'package:app/data/style.dart';
import 'package:app/screens/modal_channel_open.dart';
import 'package:app/screens/modal_close.dart';
import 'package:app/screens/modal_qr_scan.dart';
import 'package:app/screens/modal_read_message.dart';
import 'package:app/screens/modal_reject_channel.dart';
import 'package:app/screens/modal_show_qr_code.dart';
import 'package:app/screens/screen_channel_detail_screen.dart';
import 'package:app/services/ethereum_connect.dart';
import 'package:app/services/network.dart';
import 'package:app/services/link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

class NewChannel extends StatefulWidget {
  final NFCNetwork nfcNetwork;

  const NewChannel({
    super.key,
    required this.nfcNetwork,
  });

  @override
  State<StatefulWidget> createState() => _NewChannelState();
}

class _NewChannelState extends State<NewChannel> {

  List<ChannelObj> channels = MyWallet().channels;

  void update() {
    setState(() {
      channels = MyWallet().channels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            padding: const EdgeInsets.all(10.0),
            width: 110,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Style.background,
            ),
            alignment: Alignment.center,
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.plus_circled,
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    child: Text(
                      'Open Channel',
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              onTap: () async => {
                await showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ModalChannelOpen(
                    network: widget.nfcNetwork,
                  ),
                ),
                update()
              }
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
            padding: const EdgeInsets.all(10.0),
            width: 110,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Style.background,
            ),
            alignment: Alignment.center,
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.plus_circled,
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    child: Text(
                      'Scan message',
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              onTap: () async {
                String? result = await showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ModalReadMessage()
                );
                if (result != null) {
                  print(result);
                  NetworkMessage? msg = fromLink(Uri.parse(result));
                  if (msg != null) {
                    handleIncomingMessage(msg, context);
                  }
                }
                update();
              }
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            width: 110,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Style.background,
            ),
            alignment: Alignment.center,
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.plus_circled,
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    child: Text(
                      'My Wallet',
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              onTap: () => showMaterialModalBottomSheet(
                expand: false,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => ModalQR(
                  builder: QrImageView(
                    data: MyWallet().Address(),
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  data: MyWallet().Address(),
                ),
              ),
            ),
          ),
        ],
      ),
      // Building List of view based on channels
      Expanded(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: MyWallet().channels.length,
          itemBuilder: (context, i) {
            return _createChannel(MyWallet().channels[i], widget.nfcNetwork);
          },
        ),
      ),
    ]));
  }

  Widget _createChannel(ChannelObj channel, NFCNetwork network) {
    EthMetaData data = channel.currentState();
    if (channel.isActive()) {
      return Channel(
        actions: Container(
          width: 55,
          child: GestureDetector(
            child: Column(
              children: [
                Icon(
                  CupertinoIcons.clear,
                ),
                Text('Close')
              ],
            ),
            onTap: () => showMaterialModalBottomSheet(
              expand: false,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => ModalClose(
                channel: channel,
                network: network,
              ),
            ),
          ),
        ),
        head: CircleAvatar(
          radius: 14.0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFFB2A2EA),
                  Color(0xFF5842C2),
                ], // Your gradient colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChannelDetailScreen(
                    channel: channel,
                    network: network,
                  )));
        },
        state: 'You: ${data.myBal} wei | They: ${data.otherBal} wei',
        title: '',
      );
    }

    if (!channel.isActive() && data.isProposer) {
      Channel(
        actions: Container(
          width: 55,
          child: GestureDetector(
            child: Column(
              children: [
                Icon(
                  CupertinoIcons.clear,
                ),
                Text('Cancel')
              ],
            ),
            onTap: () {
              //cancel implement later
            },
          ),
        ),
        head: Icon(CupertinoIcons.arrow_2_circlepath),
        onTap: () {},
        state: 'You: ${data.myBal} wei | They: ${data.otherBal} wei',
        title: 'Pending...',
      );
    }

    if (!channel.isActive() && !data.isProposer) {
      Channel(
        actions: Row(
          children: [
            Container(
              width: 55,
              child: GestureDetector(
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.check_mark,
                    ),
                    Text('Accept')
                  ],
                ),
                onTap: () {
                  // //call function to sign
                  // showMaterialModalBottomSheet(
                  //   expand: false,
                  //   context: context,
                  //   backgroundColor: Colors.transparent,
                  //   builder: (context) => ModalAcceptChannel(
                  //     channel: channel,
                  //   ),
                  // );
                },
              ),
            ),
            Container(
              width: 55,
              child: GestureDetector(
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.clear,
                    ),
                    Text('Reject')
                  ],
                ),
                onTap: () {
                  //call function to start a new transaction to dispute
                  showMaterialModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => ModalRejectChannel(),
                  );
                },
              ),
            )
          ],
        ),
        head: Icon(CupertinoIcons.arrow_up_arrow_down),
        onTap: () {},
        state: 'You: ${data.myBal} wei | They: ${data.otherBal} wei',
        title: 'New request',
      );
    }
    return SizedBox();
  }

  Future<ui.Image> _loadOverlayImage() async {
    final Completer<ui.Image> completer = Completer<ui.Image>();
    final ByteData byteData =
        await rootBundle.load('assets/images/4.0x/logo_yakka.png');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }
}

class Channel extends StatelessWidget {
  final Widget head;
  final String title;
  final String state;
  final Widget actions;
  final Function() onTap;

  const Channel({
    super.key,
    required this.head,
    required this.title,
    required this.state,
    required this.actions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(width: 30, child: head),
              SizedBox(width: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 5),
                Text(state)
              ]),
            ]),
            actions,
          ],
        ),
      ),
    );
  }
}
