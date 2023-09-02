import 'dart:async';

import 'package:app/services/ethereum_connect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:convert/convert.dart';

import 'package:app/services/database.dart';

class NewDispute extends StatefulWidget {

  const NewDispute({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NewDisputeState();
}

class _NewDisputeState extends State<NewDispute> {

  late Future<List<ChannelObj>> data;

  @override
  void initState() {
    super.initState();
    data = MyWallet().watchDisputes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChannelObj>>(
      future: data,
      builder: (BuildContext context, AsyncSnapshot<List<ChannelObj>> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, i) {
                  if (snapshot.data != null) {
                  return Text(snapshot.data![i].toString());
                  }
                }
              ),
            ]
          );
        } else {
          data = MyWallet().watchDisputes();
          return Text('Looking for dispute events');
        }
      }
    );
  }
}