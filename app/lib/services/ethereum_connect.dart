import 'package:app/services/Channel.g.dart';
import 'package:http/http.dart';
import 'dart:math'; //used for the random number generator
import 'dart:io';
import 'dart:typed_data';

import 'package:web3dart/web3dart.dart';
import 'package:rlp/rlp.dart';

class MetaData {
  BigInt id;
  EthereumAddress us;
  EthereumAddress other;
  BigInt myBal;
  BigInt otherBal;
  bool isProposer;
  late BigInt round;

  MetaData({
    required this.id,
    required this.us,
    required this.other,
    required this.myBal,
    required this.otherBal,
    required this.isProposer,
  });

  Uint8List encode() {
    if (isProposer) {
      return Rlp.encode([us, other, myBal, otherBal, round]);
    } else {
      return Rlp.encode([other, us, otherBal, myBal, round]);
    }
  }
}

const COOPERATIVE_CLOSE_ROUND = "0xffffffffffffffffffffffffffffffff";

class ChannelObj {
  late Wallet wallet;
  late Web3Client client;
  late MetaData metadata;
  late Channel channel;
  late BigInt chainID;
  String path = "wallet.json";
  String password = "YesIHardcodeMyPasswords";
  String rpc = "http://127.0.0.1:8545";
  String contractAddr = "0x000";

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

  void connectToRPC() async {
    client = Web3Client(rpc, Client());
    EthereumAddress addr = EthereumAddress.fromHex(contractAddr); 
    chainID = await client.getChainId();
    channel = Channel(address: addr, client: client, chainId: chainID.toInt());
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

  bool isActive() {
    return metadata.round != BigInt.parse(COOPERATIVE_CLOSE_ROUND, radix: 16);
  }

  // Channel API
  MetaData currentState() {
    return metadata;
  }

  void open(String other, BigInt myBal, BigInt otherBal) async {
    BigInt id = randomBigInt();
    EthereumAddress otherAddr = EthereumAddress.fromHex(other);
    EthereumAddress myAddr = wallet.privateKey.address;
    // Call contract
    String res = await channel.open(id, myAddr, myBal, otherBal, credentials: wallet.privateKey);
    // Update Metadata
    metadata = MetaData(id: id, us: myAddr, other: otherAddr, myBal: myBal, otherBal: otherBal, isProposer: true);
  }

  void accept(BigInt id, String other, BigInt myBal, BigInt otherBal) async {
    EthereumAddress otherAddr = EthereumAddress.fromHex(other);
    EthereumAddress myAddr = wallet.privateKey.address;
    // Call contract
    String res = await channel.accept(id, credentials: wallet.privateKey);
    // Update Metadata
    metadata = MetaData(id: id, us: myAddr, other: otherAddr, myBal: myBal, otherBal: otherBal, isProposer: false);
  }

  Uint8List createCoopClose() {
    metadata.round = BigInt.parse(COOPERATIVE_CLOSE_ROUND, radix: 16);
    return wallet.privateKey.signPersonalMessageToUint8List(metadata.encode());
  }

  void coopClose(Uint8List sig) async {
    BigInt valueA;
    BigInt valueB;
    if (metadata.isProposer) {
      valueA = metadata.myBal;
      valueB = metadata.otherBal;
    } else {
      valueA = metadata.otherBal;
      valueB = metadata.myBal;
    }
    String res = await channel.cooperative_close(metadata.id, valueA, valueB, sig, credentials: wallet.privateKey);
    // update metadata
    metadata.round = BigInt.parse(COOPERATIVE_CLOSE_ROUND, radix: 16);
  }

  Uint8List sendMoney(BigInt value) {
    if (value <= BigInt.zero) {
      throw const FormatException("invalid parameter");
    }
    if (!isActive()) {
      throw const FormatException("sending on closed channel forbidden");
    }
    BigInt newMyBal = metadata.myBal - value;
    BigInt newOtherBal = metadata.otherBal + value;
    metadata.round += BigInt.one;
    _updateBalances(newMyBal, newOtherBal);
    return wallet.privateKey.signPersonalMessageToUint8List(metadata.encode());
  }

  void receivedMoney(BigInt myBal, BigInt otherBal, Uint8List sig) {
    BigInt maxBal = metadata.myBal + metadata.otherBal;
    if (myBal + otherBal != maxBal) {
      throw const FormatException("invalid parameter, destroying or creating money");
    }
    if (myBal < metadata.myBal) {
      throw const FormatException("invalid parameter, trying to take money");
    }
    // verify sig
    bool otherProposer = !metadata.isProposer;
    MetaData toTest = MetaData(id: metadata.id, us: metadata.us, other: metadata.other, myBal: myBal, otherBal: otherBal, isProposer: otherProposer);
    toTest.round = metadata.round + BigInt.one; // implicitly makes sure that the peer only signed round + 1
    /*
    Uint8List hash = keccak256(toTest);
    if (!isValidSignature(hash, sig, metadata.other)) {
      throw const FormatException("invalid parameter, invalid signature");
    }
    */
    _updateBalances(myBal, otherBal);
  }

  // helper

  void _updateBalances(BigInt myBal, BigInt otherBal) {
    metadata.myBal = myBal;
    metadata.otherBal = otherBal;
  }
}


BigInt randomBigInt() {
  const size = 256;
  final random = Random.secure();
  BigInt result = BigInt.zero;
  for (var i = 0; i < size; i++) {
    result |= BigInt.from(random.nextInt(256)) << (8 * i);
  }
  return result;
}