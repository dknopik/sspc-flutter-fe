import 'package:app/services/database.dart';
import 'package:app/services/ethereum_connect.dart';
import 'package:flutter/cupertino.dart';

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
                      return Text(metaData.id.toString());
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
