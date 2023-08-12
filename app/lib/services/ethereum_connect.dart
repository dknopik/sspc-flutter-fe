import 'package:app/services/Channel.g.dart';
import 'package:http/http.dart';
import 'dart:math'; //used for the random number generator
import 'dart:io';
import 'dart:typed_data';

import 'package:web3dart/web3dart.dart';
import 'package:rlp/rlp.dart';

const COOPERATIVE_CLOSE_ROUND = "0xffffffffffffffffffffffffffffffff";

class MyWallet {
  late Wallet wallet;
  late Web3Client client;
  late Channel contract;
  late BigInt chainID;
  String path = "wallet.json";
  String password = "YesIHardcodeMyPasswords";
  String rpc = "http://127.0.0.1:8545";
  String contractAddr = "0x000";
  late List<ChannelObj> channels;

  void init() async {
    // Create (or open) wallet
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
    // connect to RPC client
    client = Web3Client(rpc, Client());
    EthereumAddress addr = EthereumAddress.fromHex(contractAddr); 
    chainID = await client.getChainId();
    contract = Channel(address: addr, client: client, chainId: chainID.toInt());
  }

  ChannelObj createNewChannel() {
    ChannelObj obj = ChannelObj(wallet: wallet, channel: contract, client: client);
    channels.add(obj);
    return obj;
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

}

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

class StateUpdate {
  BigInt myBal;
  BigInt otherBal;
  BigInt round;
  Uint8List signature;

  StateUpdate({
    required this.myBal,
    required this.otherBal,
    required this.round,
    required this.signature,
  });
}

class ChannelObj {
  Wallet wallet;
  Web3Client client;
  Channel channel;
  late MetaData metadata;

  ChannelObj({
    required this.wallet,
    required this.channel,
    required this.client,
  });

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
    Transaction tx = Transaction(value: EtherAmount.fromBigInt(EtherUnit.wei, myBal));
    String res = await channel.open(id, myAddr, myBal, otherBal, credentials: wallet.privateKey, transaction: tx);
    // Update Metadata
    metadata = MetaData(id: id, us: myAddr, other: otherAddr, myBal: myBal, otherBal: otherBal, isProposer: true);
  }

  void accept(BigInt id, String other, BigInt myBal, BigInt otherBal) async {
    EthereumAddress otherAddr = EthereumAddress.fromHex(other);
    EthereumAddress myAddr = wallet.privateKey.address;
    // Call contract
    Transaction tx = Transaction(value: EtherAmount.fromBigInt(EtherUnit.wei, myBal));
    String res = await channel.accept(id, credentials: wallet.privateKey, transaction: tx);
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

  StateUpdate sendMoney(BigInt value) {
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
    Uint8List sig = wallet.privateKey.signPersonalMessageToUint8List(metadata.encode());
    return StateUpdate(myBal: newMyBal, otherBal: newOtherBal, round: metadata.round , signature: sig);
  }

  void receivedMoney(StateUpdate update) {
    // Exchange myBal and otherBal in the update
    BigInt tmp = update.myBal;
    update.myBal = update.otherBal;
    update.otherBal = tmp;

    BigInt maxBal = metadata.myBal + metadata.otherBal;
    if (update.myBal + update.otherBal != maxBal) {
      throw const FormatException("invalid parameter, destroying or creating money");
    }
    if (update.myBal < metadata.myBal) {
      throw const FormatException("invalid parameter, trying to take money");
    }
    if (update.round != metadata.round + BigInt.one) {
      throw const FormatException("invalid parameter, round not consecutive");
    }
    // verify sig
    bool otherProposer = !metadata.isProposer;
    MetaData toTest = MetaData(id: metadata.id, us: metadata.us, other: metadata.other, myBal: update.myBal, otherBal: update.otherBal, isProposer: otherProposer);
    toTest.round = metadata.round + BigInt.one; // implicitly makes sure that the peer only signed round + 1
    /*
    Uint8List hash = keccak256(toTest);
    if (!isValidSignature(hash, sig, metadata.other)) {
      throw const FormatException("invalid parameter, invalid signature");
    }
    */
    _updateBalances(update.myBal, update.otherBal);
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