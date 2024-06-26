import 'package:app/data/style.dart';
import 'package:app/screens/modal_accept.dart';
import 'package:app/screens/modal_close.dart';
import 'package:app/screens/modal_reject.dart';
import 'package:app/services/ethereum_connect.dart';
import 'package:app/services/formatting.dart';
import 'package:app/services/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../services/link.dart';
import 'modal_propose.dart';
import 'modal_show_qr_code.dart';

class ChannelDetailScreen extends StatefulWidget {
  final ChannelObj channel;

  ChannelDetailScreen({
    super.key,
    required this.channel,
  });

  @override
  State<ChannelDetailScreen> createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: Colors.white,
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            color: CupertinoColors.black,
          ),
          middle: RichText(
              text: TextSpan(
            children: [
              TextSpan(
                text: 'SSPC',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
              ),
            ],
          )),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFF6F7FC),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current State',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    height: 1.1,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20.0,
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.blue,
                                              Colors.green
                                            ], // Your gradient colors
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: formatValue(widget.channel.history.last.myBal),
                                          style: Style.title,
                                        ),
                                      ],
                                    )),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 70,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      formatValue(widget.channel.history.last.otherBal),
                                      style: TextStyle(
                                        color: Color(0xFF565559),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        height: 1.1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    CircleAvatar(
                                      radius: 12.0,
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
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Text(
                              'opening state: You: ${formatValue(widget.channel.history.first.myBal)} | They: ${formatValue(widget.channel.history.first.otherBal)}',
                              style: Style.hidden,
                            ),
                          ],
                        )
                      ],
                    )),
              ),

              // !!!!!
              // if (state[0].signedByA &&
              //     state[0]
              //         .signedByB) // last one settled, able to propose a new one
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        shape: BoxShape.circle),
                    child: GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.arrow_up,
                          ),
                          Text('Send')
                        ],
                      ),
                      onTap: () async => {
                          await showMaterialModalBottomSheet(
                            expand: false,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ModalPropose(
                                sending: true,
                                prevA: widget.channel.history.last.myBal,
                                prevB: widget.channel.history.last.otherBal,
                                channel: widget.channel,
                            ),
                          ),
                          //update()
                      }
                    ),
                  ),
                  /*
                  Receive button
                  Container(
                    width: 70,
                    height: 70,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        shape: BoxShape.circle),
                    child: GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.arrow_down,
                          ),
                          Text('Receive')
                        ],
                      ),
                      onTap: () => showMaterialModalBottomSheet(
                        expand: false,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ModalPropose(
                          sending: false,
                          prevA: state.last.myBal,
                          prevB: state.last.otherBal,
                          channel: widget.channel,
                          network: widget.network,
                        ),
                      ),
                    ),
                  ),
                  */
                  Container(
                    width: 70,
                    height: 70,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        shape: BoxShape.circle),
                    child: GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          channel: widget.channel,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Transaction History',
                  style: Style.normal,
                ),
              ),
              Divider(
                color: Colors.grey
              ),
              // a list of all the proposed transactions, both signed and unsigned, in sequence
              // highlight the ones signed by both parties - non proposal ones
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: widget.channel.history.length,
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        return Transaction(update: widget.channel.history[i], prevUpdate: null);
                      } else {
                        return Transaction(update: widget.channel.history[i], prevUpdate: widget.channel.history[i-1]);
                      }
                    },
                  ),
                )
              ),

              // receiver side: accept with signature; deny (what happens? send old transaction back?)
              // ? can receiver also propose something that requires A's signature?
              // history states: From who to who; value; signed by A/B; nonce/index
            ],
          ),
        ),
      ),
    );
  }
}

class Transaction extends StatelessWidget {

  final StateUpdate update;
  final StateUpdate? prevUpdate;

  const Transaction({
    super.key,
    required this.update,
    required this.prevUpdate,
  });

  @override
  Widget build(BuildContext context) {
    String title = ""; 
    if (update.round == BigInt.zero) {
      title = update.sender == WE_SEND ? "We" : "Peer";
      title += " proposed channel";
    } else {
      if (prevUpdate == null) {
        // should never happen, only the 0 round has no previous round
        throw Exception("should not happen");
      }
      title = update.sender == WE_SEND 
        ? 'sending ${prevUpdate!.myBal - update.myBal}'
        : 'receiving ${update.myBal - prevUpdate!.myBal}';
    }
    String state = 'You: ${formatValue(update.myBal)} | They: ${formatValue(update.otherBal)}';
    
    return InkWell(
      onTap: () {
        if (update.sender == WE_SEND) {
          String link = toLink(fromStateUpdate(update));
          showMaterialModalBottomSheet(
            expand: false,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => ModalQR(
              builder: QrImageView(
                data: link,
                version: QrVersions.auto,
                size: 200.0,
              ),
              data: link,
            )
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(width: 30, child:
                Icon(
                  update.round == BigInt.zero
                      ? CupertinoIcons.arrow_right_arrow_left
                      : update.sender == WE_SEND
                        ? CupertinoIcons.arrow_up
                        : CupertinoIcons.arrow_down,
                      )),
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
          ],
        ),
      )
    );
  }
}
