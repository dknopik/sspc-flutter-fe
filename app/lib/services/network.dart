import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:app/services/ethereum_connect.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;

class NFCNetwork {
  Future<bool> isAvailable() async {
    var availability = await FlutterNfcKit.nfcAvailability;
    return availability == NFCAvailability.available;
  }

  void send(List<NetworkMessage> objects) async {
    if (!await isAvailable()) {
      return;
    }

    var tag = await FlutterNfcKit.poll(
        timeout: Duration(seconds: 10),
        iosMultipleTagMessage: "Multiple tags found!",
        iosAlertMessage: "Scan your tag");

    // write NDEF records if applicable
    if (tag.ndefWritable.isDefinedAndNotNull && tag.ndefWritable!) {
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
    if (tag.ndefAvailable.isDefinedAndNotNull && tag.ndefAvailable!) {
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

NetworkMessage fromID(BigInt id) {
  return NetworkMessage(type: 0, myBal: BigInt.zero, otherBal: BigInt.zero, round: BigInt.zero, signature: Uint8List(0), id: id);
}

StateUpdate asStateUpdate(NetworkMessage msg) {
  if (msg.type == 1) {
    return StateUpdate(
        myBal: msg.myBal,
        otherBal: msg.otherBal,
        round: msg.round,
        signature: msg.signature);
  }
  throw const FormatException("invalid parameter");
}

Uint8List hexToUint8List(String hex) {
  if (hex.length % 2 != 0) {
    throw 'Odd number of hex digits';
  }
  var l = hex.length ~/ 2;
  var result = Uint8List(l);
  for (var i = 0; i < l; ++i) {
    var x = int.parse(hex.substring(2 * i, 2 * (i + 1)), radix: 16);
    if (x.isNaN) {
      throw 'Expected hex string';
    }
    result[i] = x;
  }
  return result;
}
