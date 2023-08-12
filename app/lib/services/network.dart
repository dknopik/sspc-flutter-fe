import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/services/ethereum_connect.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:app/screens/modal_accept_channel.dart';
import 'package:ndef/ndef.dart' as ndef;

class NFCNetwork {

  void startListener(BuildContext context, MyWallet wallet) async {
    while(true) {
      List<NetworkMessage> messages = await read();
      for (final msg in messages) {
        switch (msg.type) {
          case 0: // Channel announcement
            ChannelObj channel = wallet.createNewChannel();
            // trigger modal
            showMaterialModalBottomSheet(
              expand: false,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => ModalAcceptChannel(
                channel: channel,
                id: msg.id,
                myBal: msg.otherBal, // turn around myBal and otherBal here
                otherBal: msg.myBal,
                other: msg.signature,
              ),
            );
            break;
          case 1: // Channel update
            BigInt id = msg.id;
            wallet.channels.forEach(
              (element) 
              {if (element.metadata.id == id) {
                element.receivedMoney(asStateUpdate(msg));
              }});
            break;
          case 2: // Channel closing
            BigInt id = msg.id;
            wallet.channels.forEach(
              (element) 
              {if (element.metadata.id == id) {
                element.coopClose(asSignature(msg));
              }});
        }
      }
      sleep(Duration(seconds: 1));
    }
  }

  Future<bool> isAvailable() async {
    var availability = await FlutterNfcKit.nfcAvailability;
    return availability == NFCAvailability.available;
  }

  void send(List<NetworkMessage> objects) async {
    print("sending");
    if (!await isAvailable()) {
      return;
    }

    var tag = await FlutterNfcKit.poll(
        timeout: Duration(seconds: 10),
        iosMultipleTagMessage: "Multiple tags found!",
        iosAlertMessage: "Scan your tag");

    // write NDEF records if applicable
    if (tag.ndefWritable != null && tag.ndefWritable!) {
      for (final object in objects) {
        await FlutterNfcKit.writeNDEFRecords(
            [ndef.TextRecord(text: jsonEncode(object.toJson()))]);
      }
    }
    await FlutterNfcKit.finish();
  }

  Future<List<NetworkMessage>> read() async {
    if (!await isAvailable()) {
      return List.empty();
    }

    var tag = await FlutterNfcKit.poll(
        timeout: Duration(seconds: 10),
        iosMultipleTagMessage: "Multiple tags found!",
        iosAlertMessage: "Scan your tag");

    List<NetworkMessage> list = List.empty(growable: true);
    // read NDEF records if available
    if (tag.ndefAvailable != null && tag.ndefAvailable!) {
      for (var record in await FlutterNfcKit.readNDEFRecords(cached: false)) {
        NetworkMessage networkMessage =
            NetworkMessage.fromJson(jsonDecode(record.toString()));
        print(networkMessage.type);
        list.add(networkMessage);
      }
    }
    await FlutterNfcKit.finish();
    return list;
  }
}

class NetworkMessage {
  int type;
  BigInt myBal;
  BigInt otherBal;
  BigInt round;
  Uint8List signature;
  BigInt id;

  NetworkMessage({
    required this.type,
    required this.myBal,
    required this.otherBal,
    required this.round,
    required this.signature,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "myBal": myBal.toString(),
      "otherBal": otherBal.toString(),
      "round": round.toString(),
      "signature": signature,
      "id": id.toString(),
    };
  }

  factory NetworkMessage.fromJson(Map<String, dynamic> json) {
    NetworkMessage networkMessage = NetworkMessage(
      type: int.parse(json["type"]),
      myBal: BigInt.parse(json["myBal"]),
      otherBal: BigInt.parse(json["otherBal"]),
      round: BigInt.parse(json["round"]),
      signature: json["signature"],
      id: BigInt.parse(json["id"]),
    );
    return networkMessage;
  }
}

NetworkMessage fromProposal(BigInt id, BigInt myBal, BigInt otherBal, Uint8List address) {
  return NetworkMessage(type: 0, myBal: myBal, otherBal: otherBal, round: BigInt.zero, signature: address, id: id);
}

NetworkMessage fromStateUpdate(StateUpdate update) {
  return NetworkMessage(type: 1, myBal: update.myBal, otherBal: update.otherBal, round: update.round, signature: update.signature, id: update.id);
}

NetworkMessage fromSig(Uint8List signature) {
  return NetworkMessage(type: 2, myBal: BigInt.zero, otherBal: BigInt.zero, round: BigInt.zero, signature: signature, id: BigInt.zero);
}

StateUpdate asStateUpdate(NetworkMessage msg) {
  return StateUpdate(
    id: msg.id,
    myBal: msg.myBal,
    otherBal: msg.otherBal,
    round: msg.round,
    signature: msg.signature);
}

Uint8List asSignature(NetworkMessage msg) {
  return msg.signature;
}
