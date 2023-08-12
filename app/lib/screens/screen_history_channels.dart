import 'package:flutter/cupertino.dart';

class HistoryChannels extends StatefulWidget {
  const HistoryChannels({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _HistoryChannelsState();
}

class _HistoryChannelsState extends State<HistoryChannels> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Text('a list of old consolidated channels || to be implemented'),
      // no detail screen implementation
    ]));
  }
}
