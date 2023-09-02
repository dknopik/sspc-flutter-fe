import 'package:app/screens/screen_new_channel.dart';
import 'package:app/services/database.dart';
import 'package:app/services/ethereum_connect.dart';
import 'package:app/screens/modal_close.dart';
import 'package:flutter/cupertino.dart';
import 'package:convert/convert.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/screen_channel_detail_screen.dart';
import 'package:app/services/network.dart';

import '../services/formatting.dart';

class HistoryChannels extends StatefulWidget {

  const HistoryChannels({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _HistoryChannelsState();
}

class _HistoryChannelsState extends State<HistoryChannels> {

  late Future<List<EthMetaData>> data;

  @override
  void initState() {
    super.initState();
    data = ChannelDB().getMetaData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EthMetaData>>(
      future: data,
      builder: (BuildContext context, AsyncSnapshot<List<EthMetaData>> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, i) {
                  EthMetaData metaData = snapshot.data!.elementAt(i);
                  String id = hex.encode(metaData.id);
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
                        /*
                        onTap: () => showMaterialModalBottomSheet(
                          expand: false,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => ModalClose(
                            channel: channel,
                            network: NFCNetwork(),
                          ),
                        ),*/
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
                              Color(int.parse(metaData.other.hexEip55.substring(2,10), radix: 16)),
                              Color(int.parse(metaData.other.hexEip55.substring(12,20), radix: 16)),
                            ], // Your gradient colors
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                    onTap: () { },
                    /*
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChannelDetailScreen(
                                channel: channel,
                                network: network,
                              )));
                    },*/
                    state: 'You: ${formatValue(metaData.myBal)} | They: ${formatValue(metaData.otherBal)}',
                    title: 'Channel ${id.substring(0, 8)} \nwith Peer ${metaData.other.hexEip55}',  
                );
            })
            ]
          );
        } else {
          data = ChannelDB().getMetaData();
          return Text('Reading database');
        }
      }
    );
  }
}
