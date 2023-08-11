import 'package:http/http.dart';
import 'dart:math'; //used for the random number generator
import 'dart:io';
import 'dart:typed_data';

import 'package:web3dart/web3dart.dart';
import 'package:rlp/rlp.dart';

class MetaData {
  late BigInt id;
  late String us;
  late String other;
  late BigInt myBal;
  late BigInt otherBal;
  late BigInt round;

  Uint8List encode(){
    return Rlp.encode([us, other, myBal, otherBal, round]);
  }
}

class Channel {
  late Wallet wallet;
  late Web3Client client;
  late MetaData channel;
  String path = "wallet.json";
  String password = "YesIHardcodeMyPasswords";
  String rpc = "http://127.0.0.1:8545";

  void openWallet() {
    try {
      String content = File("wallet.json").readAsStringSync();
      wallet = Wallet.fromJson(content, password);
    } catch (e) {
      print("Wallet not found, creating new wallet.json");
      var rng = Random.secure();
      EthPrivateKey random = EthPrivateKey.createRandom(rng);
      wallet = Wallet.createNew(random, "password", rng);
      print(wallet.toJson());
    }
  }

  void connectToRPC() {
    client = Web3Client(rpc, Client());
  }

  Future<String> getOnChainBalance() async {
    try {
      EtherAmount balance = await client.getBalance(wallet.privateKey.address);
      print(balance.getValueInUnit(EtherUnit.ether).toString());
      return balance.getValueInUnit(EtherUnit.ether).toString();
    } catch (e) {
      print(e);
    }
    return "";
  }

  // Channel API
  MetaData currentState() {
    return channel;
  }

  void open(String other, BigInt myBal, BigInt otherBal) {
    _updateMetaData(other, myBal, otherBal);

  }

  void accept(String other, BigInt myBal, BigInt otherBal) {
    _updateMetaData(other, myBal, otherBal);
  }

  void createCoopClose() {

  }

  void coopClose() {

  }

  Uint8List sendMoney(BigInt value) {
    if(value <= BigInt.zero) {
      throw const FormatException("invalid parameter");
    }
    BigInt newMyBal = channel.myBal - value;
    BigInt newOtherBal = channel.otherBal + value;
    _updateMetaData(channel.other, newMyBal, newOtherBal);
    return wallet.privateKey.signPersonalMessageToUint8List(channel.encode());
  }

  void receivedMoney(BigInt myBal, BigInt otherBal, Uint8List sig) {
    // verify sig
    _updateMetaData(channel.other, myBal, otherBal);
  }

  // helper
  
  void _updateMetaData(String other, BigInt myBal, BigInt otherBal) {
    channel.us = wallet.privateKey.address.toString();
    channel.other = other;
    channel.myBal = myBal;
    channel.otherBal = otherBal;
  }

}