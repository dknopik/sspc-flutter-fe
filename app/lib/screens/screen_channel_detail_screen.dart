import 'package:app/data/style.dart';
import 'package:app/screens/modal_accept.dart';
import 'package:app/screens/modal_close.dart';
import 'package:app/screens/modal_reject.dart';
import 'package:app/services/ethereum_connect.dart';
import 'package:app/services/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'modal_propose.dart';

class ChannelDetailScreen extends StatefulWidget {
  final ChannelObj channel;
  final NFCNetwork network;

  ChannelDetailScreen({
    super.key,
    required this.channel,
    required this.network,
  });

  @override
  State<ChannelDetailScreen> createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen> {
  int a = 2;
  int b = 13;

  List<ChannelTransaction> testData = [
    ChannelTransaction(
        prevA: 1,
        prevB: 14,
        newA: 2,
        newB: 13,
        signedByA: false,
        signedByB: true,
        init: false,
        sending: false),
    ChannelTransaction(
        prevA: 1,
        prevB: 14,
        newA: 0,
        newB: 15,
        signedByA: true,
        signedByB: false,
        init: false,
        sending: true),
    ChannelTransaction(
        prevA: 0,
        prevB: 15,
        newA: 1,
        newB: 14,
        signedByA: true,
        signedByB: true,
        init: false,
        sending: false),
    ChannelTransaction(
        prevA: 0,
        prevB: 15,
        newA: 1,
        newB: 14,
        signedByA: false,
        signedByB: true,
        init: false,
        sending: false),
    ChannelTransaction(
        prevA: 0,
        prevB: 15,
        newA: 0,
        newB: 15,
        signedByA: true,
        signedByB: true,
        init: true,
        sending: false),
    ChannelTransaction(
        prevA: 0,
        prevB: 15,
        newA: 0,
        newB: 15,
        signedByA: true,
        signedByB: false,
        init: true,
        sending: false),
  ];

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
              TextSpan(
                text: ' with Daniel',
                style: TextStyle(
                  color: Color(0xFF565559),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                ),
              )
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
                                          text: '1254',
                                          style: Style.title,
                                        ),
                                        TextSpan(
                                          text: '.00 wei',
                                          style: TextStyle(
                                            color: Color(0xFF565559),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            height: 1.1,
                                          ),
                                        )
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
                                      '13.00 wei',
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
                              'opening state: You: 0 wei | They: 15 wei',
                              style: Style.hidden,
                            ),
                          ],
                        )
                      ],
                    )),
              ),

              // !!!!!
              // if (testData[0].signedByA &&
              //     testData[0]
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
                      onTap: () => showMaterialModalBottomSheet(
                        expand: false,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ModalPropose(
                            sending: true,
                            prevA: a,
                            prevB: b,
                            channel: widget.channel,
                            network: widget.network),
                      ),
                    ),
                  ),
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
                          prevA: a,
                          prevB: b,
                          channel: widget.channel,
                          network: widget.network,
                        ),
                      ),
                    ),
                  ),
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
                          network: widget.network,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              if (!testData[0].signedByA ||
                  !testData[0]
                      .signedByB) // if either not signed, actions needed
                Transaction(
                    head: Icon(
                      testData[0].init
                          ? CupertinoIcons.arrow_right_arrow_left
                          : testData[0].sending
                              ? CupertinoIcons.arrow_up
                              : CupertinoIcons.arrow_down,
                    ),
                    title: !testData[0].init && testData[0].sending
                        ? 'sending ${testData[0].prevA - testData[0].newA}'
                        : !testData[0].init && !testData[0].sending
                            ? 'receiving ${testData[0].newA - testData[0].prevA}'
                            : ' ',
                    state:
                        'You: ${testData[0].newA} wei | They: ${testData[0].newB} wei',
                    actions: (testData[0].signedByA)
                        ? Text('waiting for confirmation')
                        : (testData[0].signedByB)
                            ? Row(
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
                                        //call function to sign
                                        showMaterialModalBottomSheet(
                                          expand: false,
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) => ModalAccept(
                                            channel: widget.channel,
                                          ),
                                        );
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
                                          builder: (context) => ModalReject(
                                            prevA: a,
                                            prevB: b,
                                            channel: widget.channel,
                                            network: widget.network,
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              )
                            : SizedBox()),

              // pending only has two state: waiting for comfirmation or waiting to sign
              // accept - go into history list; reject - start a different prop (old or new state) - pending from current side

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'history transactions',
                  style: Style.normal,
                ),
              ),

              // a list of all the proposed transactions, both signed and unsigned, in sequence
              // highlight the ones signed by both parties - non proposal ones
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: testData.length,
                  itemBuilder: (context, i) {
                    return Transaction(
                      head: Icon(
                        testData[i].init
                            ? CupertinoIcons.arrow_right_arrow_left
                            : testData[i].sending
                                ? CupertinoIcons.arrow_up
                                : CupertinoIcons.arrow_down,
                      ),
                      title: !testData[i].init && testData[i].sending
                          ? 'sending ${testData[i].prevA - testData[i].newA}'
                          : !testData[i].init && !testData[i].sending
                              ? 'receiving ${testData[i].newA - testData[i].prevA}'
                              : ' ',
                      state:
                          'You: ${testData[i].newA} wei | They: ${testData[i].newB} wei',
                      actions: Container(
                        width: 55,
                        child: Column(
                          children: [
                            Icon(
                              testData[i].signedByA && !testData[i].signedByB
                                  ? CupertinoIcons.square_arrow_up
                                  : !testData[i].signedByA &&
                                          testData[i].signedByB
                                      ? CupertinoIcons.square_arrow_down
                                      : CupertinoIcons.check_mark,
                            ),
                            Text(
                              testData[i].signedByA && !testData[i].signedByB
                                  ? 'propose'
                                  : !testData[i].signedByA &&
                                          testData[i].signedByB
                                      ? 'request'
                                      : 'settled',
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
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

class ChannelTransaction {
  int prevA;
  int prevB;
  int newA;
  int newB;
  bool sending;
  bool signedByA; //proposal
  bool signedByB; //confirmation
  bool
      init; //case when it is not sending nor receiving, i.e., initial transaction or amount unchanged.

  ChannelTransaction({
    required this.prevA,
    required this.prevB,
    required this.newA,
    required this.newB,
    this.sending = false,
    this.signedByA = false,
    this.signedByB = false,
    this.init = false,
  });
}

class Transaction extends StatelessWidget {
  final Widget head;
  final String title;
  final String state;
  final Widget actions;

  const Transaction({
    super.key,
    required this.head,
    required this.title,
    required this.state,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
