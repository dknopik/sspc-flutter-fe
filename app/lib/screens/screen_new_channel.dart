import 'package:app/screens/modal_accept_channel.dart';
import 'package:app/screens/modal_channel_open.dart';
import 'package:app/screens/modal_close.dart';
import 'package:app/screens/modal_reject_channel.dart';
import 'package:app/screens/screen_channel_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NewChannel extends StatefulWidget {
  const NewChannel({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NewChannelState();
}

class _NewChannelState extends State<NewChannel> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      GestureDetector(
        child: Column(
          children: [
            Icon(
              CupertinoIcons.plus_circled,
            ),
            Text('Open')
          ],
        ),
        onTap: () => showMaterialModalBottomSheet(
          expand: false,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => ModalChannelOpen(),
        ),
      ),
      //channel await for reactions
      // channel await for actions
      Container(
          child: Row(
        children: [
          Text('new channel'),
          Column(children: [
            Text('A: 22'),
            Text('B:  12'),
          ]),
          Text('cancel implement later')
        ],
      )),
      Container(
          child: Row(
        children: [
          Text('new channel'),
          Column(children: [
            Text('A: 12'),
            Text('B:  12'),
          ]),
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
                    builder: (context) => ModalAcceptChannel(),
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
                    builder: (context) => ModalRejectChannel(),
                  );
                },
              )
            ],
          )
        ],
      )),
      //current active channels
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ChannelDetailScreen()));
        },
        child: Container(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('B'),
            Column(children: [
              Text('A: 2'),
              Text('B: 13'),
            ]),
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
            //pass in transactional data etc
          ]),
        ),
      )
    ]));
  }
}
