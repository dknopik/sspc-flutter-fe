import 'package:app/screens/modal_accept.dart';
import 'package:app/screens/modal_close.dart';
import 'package:app/screens/modal_reject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'modal_propose.dart';

class ChannelDetailScreen extends StatefulWidget {
  const ChannelDetailScreen({super.key});

  @override
  State<ChannelDetailScreen> createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen> {
  void _incrementCounter() {
    setState(() {});
  }

  double a = 2;
  double b = 13;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel with XX'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Current State',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '2 unit',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  '<--->',
                ),
                Text(
                  'XX: 13 unit',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const Text(
              'Initial State',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0 unit',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  '<--->',
                ),
                Text(
                  'XX: 15 unit',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            // if (testData[0].signedByA &&
            //     testData[0]
            //         .signedByB) // last one settled, able to propose a new one
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Column(
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
                    ),
                  ),
                ),
                GestureDetector(
                  child: Column(
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
                    ),
                  ),
                ),
                GestureDetector(
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
                    builder: (context) => ModalClose(),
                  ),
                ),
              ],
            ),
            if (!testData[0].signedByA ||
                !testData[0].signedByB) // if either not signed, actions needed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    testData[0].init
                        ? CupertinoIcons.arrow_right_arrow_left
                        : testData[0].sending
                            ? CupertinoIcons.arrow_up
                            : CupertinoIcons.arrow_down,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        !testData[0].init && testData[0].sending
                            ? 'sending ${testData[0].prevA - testData[0].newA}'
                            : !testData[0].init && !testData[0].sending
                                ? 'receiving ${testData[0].newA - testData[0].prevA}'
                                : ' ',
                      ),
                      Text(
                        '${testData[0].newA} <-> ${testData[0].newB}',
                      ),
                    ],
                  ),
                  if (testData[0].signedByA) Text('waiting for confirmation'),
                  if (testData[0].signedByB)
                    Row(
                      children: [
                        GestureDetector(
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
                              builder: (context) => ModalAccept(),
                            );
                          },
                        ),
                        GestureDetector(
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
                              ),
                            );
                          },
                        )
                      ],
                    )
                ],
              ),
            // pending only has two state: waiting for comfirmation or waiting to sign
            // accept - go into history list; reject - start a different prop (old or new state) - pending from current side
            Text('history transactions'),
            // a list of all the proposed transactions, both signed and unsigned, in sequence
            // highlight the ones signed by both parties - non proposal ones
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: testData.length,
                itemBuilder: (context, i) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        testData[i].init
                            ? CupertinoIcons.arrow_right_arrow_left
                            : testData[i].sending
                                ? CupertinoIcons.arrow_up
                                : CupertinoIcons.arrow_down,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            !testData[i].init && testData[i].sending
                                ? 'sending ${testData[i].prevA - testData[i].newA}'
                                : !testData[i].init && !testData[i].sending
                                    ? 'receiving ${testData[i].newA - testData[i].prevA}'
                                    : ' ',
                          ),
                          Text(
                            '${testData[i].newA} <-> ${testData[i].newB}',
                          ),
                        ],
                      ),
                      Column(
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
                      )
                    ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ChannelTransaction {
  double prevA;
  double prevB;
  double newA;
  double newB;
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
