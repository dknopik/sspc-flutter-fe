import 'package:app/data/style.dart';
import 'package:app/screens/modal_accept_channel.dart';
import 'package:app/screens/modal_channel_open.dart';
import 'package:app/screens/modal_close.dart';
import 'package:app/screens/modal_reject_channel.dart';
import 'package:app/screens/screen_channel_detail_screen.dart';
import 'package:app/services/ethereum_connect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NewChannel extends StatefulWidget {
  final MyWallet myWallet;

  const NewChannel({
    super.key,
    required this.myWallet,
  });

  @override
  State<StatefulWidget> createState() => _NewChannelState();
}

class _NewChannelState extends State<NewChannel> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Container(
        margin: const EdgeInsets.all(20.0),
        width: 180,
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
          onTap: () => showMaterialModalBottomSheet(
            expand: false,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => ModalChannelOpen(
              myWallet: widget.myWallet,
            ),
          ),
        ),
      ),
      // Building List of view based on channels
      Expanded(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.myWallet.channels.length,
          itemBuilder: (context, i) {
            return _createChannel(widget.myWallet.channels[i]);
          },
        ),
      ),
    ]));
  }

  Widget _createChannel(ChannelObj channel) {
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
                  //call function to sign
                  showMaterialModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => ModalAcceptChannel(
                      channel: channel,
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
