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

    var tag = await FlutterNfcKit.poll(timeout: Duration(seconds: 10),
          iosMultipleTagMessage: "Multiple tags found!", iosAlertMessage: "Scan your tag");

    // write NDEF records if applicable
    if (tag.ndefWritable.isDefinedAndNotNull && tag.ndefWritable!) {
      for (final object in objects) {
        await FlutterNfcKit.writeNDEFRecords([ndef.TextRecord(text: object.toString())]);
      }
    }
    await FlutterNfcKit.finish();
  }

  Future<List<String>> read() async {
    if (!await isAvailable()) {
      return List.empty();      
    }

    var tag = await FlutterNfcKit.poll(timeout: Duration(seconds: 10),
          iosMultipleTagMessage: "Multiple tags found!", iosAlertMessage: "Scan your tag");

    List<String> list = List.empty(growable: true);
    // read NDEF records if available
    if (tag.ndefAvailable.isDefinedAndNotNull && tag.ndefAvailable!){
      for (var record in await FlutterNfcKit.readNDEFRecords(cached: false)) {
        print(record.toString());
        list.add(record.toString());
      }
    }
    await FlutterNfcKit.finish();
    return list;
  } 
}

class NetworkMessage {
  int type;
  String message;

  NetworkMessage({
    required this.type,
    required this.message,
  });

  String toString() {
    String message = "";
    message += type.toString();
    message += "\n";
    message += this.message;
    return message;
  }

  fromString(String s) {
    List<String> subMsg = s.split("\n");
    type = int.parse(subMsg.first);
    message = s.substring(subMsg.first.length);
  }
}


NetworkMessage IDasNM(BigInt id) {
  return NetworkMessage(type: 0, message: id.toString());
}

BigInt AsId(NetworkMessage msg) {
  if (msg.type == 0) {
    return BigInt.parse(msg.message);
  }
  throw const FormatException("invalid parameter");
}

NetworkMessage StateUpdateasNM(StateUpdate update) {
  String message = "";
  message += update.myBal.toString();
  message += "\n";
  message += update.otherBal.toString();
  message += "\n";
  message += update.round.toString();
  message += "\n";
  message += update.signature.toHexString();
  return NetworkMessage(type: 1, message: message);
}

StateUpdate NMasStateUpdate(NetworkMessage msg) {
  if (msg.type == 1) {
    List<String> subMsg = msg.message.split("\n");
    if (subMsg.length != 4) {
      throw const FormatException("invalid parameter");  
    }
    BigInt myBal = BigInt.parse(subMsg.elementAt(0));
    BigInt otherBal = BigInt.parse(subMsg.elementAt(1));
    BigInt round = BigInt.parse(subMsg.elementAt(2));
    Uint8List signature = hexToUint8List(subMsg.elementAt(3));
    return StateUpdate(myBal: myBal, otherBal: otherBal, round: round, signature: signature);
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