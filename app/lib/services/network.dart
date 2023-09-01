import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/services/ethereum_connect.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:app/screens/modal_accept_channel.dart';
import 'package:web3dart/crypto.dart';
import 'package:ndef/ndef.dart' as ndef;

class NFCNetwork {

  void startListener(BuildContext context) async {
    while(true) {
      List<NetworkMessage> messages = await read();
      for (final msg in messages) {
        handleIncomingMessage(msg, context);
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
  Uint8List sigOrAddr;
  Uint8List id;

  NetworkMessage({
    required this.type,
    required this.myBal,
    required this.otherBal,
    required this.round,
    required this.sigOrAddr,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "myBal": myBal.toString(),
      "otherBal": otherBal.toString(),
      "round": round.toString(),
      "signature": sigOrAddr.toHexString(),
      "id": id.toHexString(),
    };
  }

  factory NetworkMessage.fromJson(Map<String, dynamic> json) {
    NetworkMessage networkMessage = NetworkMessage(
      type: json["type"],
      myBal: BigInt.parse(json["myBal"]),
      otherBal: BigInt.parse(json["otherBal"]),
      round: BigInt.parse(json["round"]),
      sigOrAddr: hexToBytes(json["signature"]),
      id: hexToBytes(json["id"]),
    );
    return networkMessage;
  }
}

NetworkMessage fromProposal(Uint8List id, BigInt myBal, BigInt otherBal, Uint8List address) {
  return NetworkMessage(type: 0, myBal: myBal, otherBal: otherBal, round: BigInt.zero, sigOrAddr: address, id: id);
}

NetworkMessage fromStateUpdate(StateUpdate update) {
  return NetworkMessage(type: 1, myBal: update.myBal, otherBal: update.otherBal, round: update.round, sigOrAddr: update.signature, id: update.id);
}

NetworkMessage fromSig(Uint8List signature) {
  return NetworkMessage(type: 2, myBal: BigInt.zero, otherBal: BigInt.zero, round: BigInt.zero, sigOrAddr: signature, id: Uint8List(32));
}

StateUpdate asStateUpdate(NetworkMessage msg) {
  return StateUpdate(
    id: msg.id,
    myBal: msg.myBal,
    otherBal: msg.otherBal,
    round: msg.round,
    signature: msg.sigOrAddr);
}

Uint8List asSignature(NetworkMessage msg) {
  return msg.sigOrAddr;
}

void handleIncomingMessage(NetworkMessage msg, BuildContext context) {
  switch (msg.type) {
    case 0: // Channel announcement
      ChannelObj channel = MyWallet().createNewChannel();
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
          other: msg.sigOrAddr,
        ),
      );
      break;
    case 1: // Channel update
      Uint8List id = msg.id;
      MyWallet().channels.forEach(
              (element)
          {if (element.metadata.id == id) {
            element.receivedMoney(asStateUpdate(msg));
          }});
      break;
    case 2: // Channel closing
      Uint8List id = msg.id;
      MyWallet().channels.forEach(
              (element)
          {if (element.metadata.id == id) {
            element.coopClose(asSignature(msg));
          }});
  }
}
