import 'dart:async';

import 'package:app/services/ethereum_connect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:convert/convert.dart';
import 'package:app/data/style.dart';

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
          if (snapshot.data!.isEmpty) {
            return TextBox(title: 'No dispute events found');
          }
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
          return TextBox(title: 'Looking for dispute events');
        }
      }
    );
  }
}

class TextBox extends StatelessWidget {
  final String title;

  const TextBox({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Style.background,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                SizedBox(width: 20),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                ]),
              ]),
            ],
          ),
        ),
    );
  }
}
