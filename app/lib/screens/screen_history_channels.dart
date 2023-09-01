import 'package:app/services/database.dart';
import 'package:app/services/ethereum_connect.dart';
import 'package:flutter/cupertino.dart';
import 'package:convert/convert.dart';

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
                  String id = hex.encode(metaData.id).substring(0, 8);
                  String us = metaData.myBal.toString();
                  String other = metaData.otherBal.toString();
                  String peer = metaData.other.hexEip55;
                  return Text("ID: $id Us: $us Other: $other Peer: $peer");
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
