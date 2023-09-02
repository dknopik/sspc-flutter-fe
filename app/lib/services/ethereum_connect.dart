import 'dart:io';
import 'dart:math';

import 'package:app/services/Channel.g.dart';
import 'package:app/services/database.dart';
import 'package:app/services/platform.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import 'package:web3dart/web3dart.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/credentials.dart';
import 'package:rlp/rlp.dart';

const COOPERATIVE_CLOSE_ROUND = "ffffffffffffffffffffffffffffffff";
const FILTER_OFFSET = 1000;
const CONTRACT_ADDR = "0xa23Cd49f677431f4eB23226b8c2150E24912070f";
const WE_SEND = true;
const PEER_SEND = false;

class MyWallet {

  static final MyWallet _instance = MyWallet._internal();
 
  factory MyWallet() {
    return _instance;
  }

  MyWallet._internal() {
    initialization = init();
  }

  late Wallet wallet;
  late Web3Client client;
  late Channel contract;
  late BigInt chainID;
  String path = "wallet.json";
  String password = "YesIHardcodeMyPasswords";
  String rpc = "https://rpc.public.zkevm-test.net";
  List<ChannelObj> channels = List.empty(growable: true);
  late Future<void> initialization;

  Future<void> init() async {
    // Correctly get the wallet path on all systems.
    String fullPath = "";
    try {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      fullPath = "${appDocDirectory.path}/$path";
    } catch(e) {
      fullPath = path;
    }
    // Create (or open) wallet
    try {
      print(fullPath);
      wallet = Wallet.fromJson(loadFile(fullPath), password);
      print("Successfully read wallet from file");
    } catch (e) {
      print("Wallet not found, creating new wallet.json");
      var rng = Random.secure();
      wallet = Wallet.createNew(EthPrivateKey.createRandom(rng), password, rng);
      // Write the wallet to disk
      storeFile(fullPath, wallet.toJson());
      print(wallet.toJson());
    }
    // connect to RPC client
    client = Web3Client(rpc, Client());
    EthereumAddress addr = EthereumAddress.fromHex(CONTRACT_ADDR);
    chainID = await client.getChainId();
    contract = Channel(address: addr, client: client, chainId: chainID.toInt());
  }

  String Address() {
    return wallet.privateKey.address.hexEip55;
  }

  ChannelObj createNewChannel() {
    ChannelObj obj =
        ChannelObj(wallet: wallet, contract: contract, client: client);
    channels.add(obj);
    return obj;
  }

  Future<BigInt> getTotalBalance() async {
    await initialization;
    BigInt bal = await getOnChainBalance();
    for (final channel in channels) {
      bal += channel.metadata.myBal;
    }
    return bal;
  }

  Future<BigInt> getOnChainBalance() async {
    await initialization;
    try {
      EtherAmount balance = await client.getBalance(wallet.privateKey.address);
      print(balance.getInWei);
      return balance.getInWei;
    } catch (e) {
      print(e);
    }
    return BigInt.zero;
  }

  Uint8List address() {
    return wallet.privateKey.address.addressBytes;
  }

  void setupDisputeWatcher() async {
    while (true) {
      Stream<Closing> stream = await waitForClosingEvent();
      await for (Closing event in stream) {
        for (ChannelObj chan in channels) { 
          // TODO this could be done a bit better, but hackathon
          if (event.ID == chan.metadata.id) {
            // We found a dispute for one of our channels
            
          }
        }
      }
      sleep(Duration(seconds: 10));
    }
  }


  // Event filtering

  Future<Stream<Open>> waitForOpenEvent() async {
    int currentBlock = await client.getBlockNumber();
    if (currentBlock < FILTER_OFFSET) {
      throw const FormatException("current block too low");
    }
    BlockNum from = BlockNum.exact(currentBlock - FILTER_OFFSET);
    return contract.openEvents(fromBlock: from, toBlock: BlockNum.current());
  }

  Future<Stream<Accepted>> waitForAcceptedEvent() async {
    int currentBlock = await client.getBlockNumber();
    if (currentBlock < FILTER_OFFSET) {
      throw const FormatException("current block too low");
    }
    BlockNum from = BlockNum.exact(currentBlock - FILTER_OFFSET);
    return contract.acceptedEvents(
        fromBlock: from, toBlock: BlockNum.current());
  }

  Future<Stream<Closing>> waitForClosingEvent() async {
    int currentBlock = await client.getBlockNumber();
    if (currentBlock < FILTER_OFFSET) {
      throw const FormatException("current block too low");
    }
    BlockNum from = BlockNum.exact(currentBlock - FILTER_OFFSET);
    return contract.closingEvents(fromBlock: from, toBlock: BlockNum.current());
  }

  Future<Stream<Closed>> waitForClosedEvent() async {
    int currentBlock = await client.getBlockNumber();
    if (currentBlock < FILTER_OFFSET) {
      throw const FormatException("current block too low");
    }
    BlockNum from = BlockNum.exact(currentBlock - FILTER_OFFSET);
    return contract.closedEvents(fromBlock: from, toBlock: BlockNum.current());
  }
}

class EthMetaData {
  Uint8List id;
  EthereumAddress us;
  EthereumAddress other;
  BigInt myBal;
  BigInt otherBal;
  bool isProposer;
  BigInt round;

  EthMetaData({
    required this.id,
    required this.us,
    required this.other,
    required this.myBal,
    required this.otherBal,
    required this.isProposer,
    required this.round,
  });

  Uint8List encode() {
    if (isProposer) {
      return Rlp.encode([us.addressBytes, other.addressBytes, myBal, otherBal, round]);
    } else {
      return Rlp.encode([other.addressBytes, us.addressBytes, otherBal, myBal, round]);
    }
  }

  Map<String, dynamic> toMap() {
    int proposer = 0;
    if (isProposer) {
      proposer = 1;
    }
    return {
      'id': id,
      'us': us.hexEip55,
      'other': other.hexEip55,
      'myBal': myBal.toString(),
      'otherBal': otherBal.toString(),
      'isProposer': proposer,
      'round': round.toString(),
    };
  }
}

class StateUpdate {
  Uint8List id;
  BigInt myBal;
  BigInt otherBal;
  BigInt round;
  bool sender;
  Uint8List signature;

  StateUpdate({
    required this.id,
    required this.myBal,
    required this.otherBal,
    required this.round,
    required this.sender,
    required this.signature,
  });

  Map<String, dynamic> toMap() {
    int senderInt = 0;
    if (sender) {
      senderInt = 1;
    }
    return {
      'channelID': id,
      'myBal': myBal.toString(),
      'otherBal': otherBal.toString(),
      'sender': senderInt,
      'round': round.toString(),
      'signature': signature,
    };
  }
}

class ChannelObj {
  Wallet wallet;
  Web3Client client;
  Channel contract;
  EthMetaData metadata = EthMetaData(id: Uint8List(32), us: EthereumAddress.fromHex(CONTRACT_ADDR) , other: EthereumAddress.fromHex(CONTRACT_ADDR), myBal: BigInt.zero, otherBal: BigInt.zero, isProposer: false, round: BigInt.zero);
  List<StateUpdate> history = List.empty(growable: true);

  ChannelObj({
    required this.wallet,
    required this.contract,
    required this.client,
  });

  bool isActive() {
    return metadata.round != BigInt.parse(COOPERATIVE_CLOSE_ROUND, radix: 16);
  }

  // Channel API
  EthMetaData currentState() {
    return metadata;
  }

  void addUpdate(StateUpdate update) {
    history.add(update);
    ChannelDB().insertStateUpdate(update);
  }

  Future<Uint8List> open(EthereumAddress otherAddr, BigInt myBal, BigInt otherBal) async {
    Uint8List id = randomID();
    print(id);
    EthereumAddress myAddr = wallet.privateKey.address;
    // Call contract
    Transaction tx =
        Transaction(value: EtherAmount.fromBigInt(EtherUnit.wei, myBal));
    String res = await contract.open(id, otherAddr, myBal, otherBal,
        credentials: wallet.privateKey, transaction: tx);
    // Update Metadata
    metadata = EthMetaData(
        id: id,
        us: myAddr,
        other: otherAddr,
        myBal: myBal,
        otherBal: otherBal,
        isProposer: true,
        round: BigInt.zero);
    ChannelDB().insertMetaData(metadata);
    // Update History
    addUpdate(StateUpdate(
        id: id,
        myBal: myBal,
        otherBal: otherBal,
        round: BigInt.zero,
        sender: WE_SEND,
        signature: Uint8List(0)));
    return id;
  }

  Future<void> accept(Uint8List id, EthereumAddress otherAddr, BigInt myBal, BigInt otherBal) async {
    EthereumAddress myAddr = wallet.privateKey.address;
    // Call contract
    Transaction tx =
        Transaction(value: EtherAmount.fromBigInt(EtherUnit.wei, myBal));
    String res = await contract.accept(id,
        credentials: wallet.privateKey, transaction: tx);
    // Insert Metadata
    metadata = EthMetaData(
        id: id,
        us: myAddr,
        other: otherAddr,
        myBal: myBal,
        otherBal: otherBal,
        isProposer: false,
        round: BigInt.zero);
    ChannelDB().insertMetaData(metadata);
    // Update History
    addUpdate(StateUpdate(
      id: id,
      myBal: myBal,
      otherBal: otherBal,
      round: BigInt.zero,
      sender: PEER_SEND,
      signature: Uint8List(0)));
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
    String res = await contract.cooperativeClose(
        metadata.id, valueA, valueB, sig,
        credentials: wallet.privateKey);
    // update metadata
    metadata.round = BigInt.parse(COOPERATIVE_CLOSE_ROUND, radix: 16);
    ChannelDB().updateMetaData(metadata);  
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
    Uint8List sig =
        wallet.privateKey.signPersonalMessageToUint8List(metadata.encode());
    ChannelDB().updateMetaData(metadata);
    // Update History
    StateUpdate update = StateUpdate(
        id: metadata.id,
        myBal: newMyBal,
        otherBal: newOtherBal,
        round: metadata.round,
        sender: WE_SEND,
        signature: sig);
    addUpdate(update);
    return update;
  }

  void receivedMoney(StateUpdate update) {
    // Exchange myBal and otherBal in the update
    BigInt tmp = update.myBal;
    update.myBal = update.otherBal;
    update.otherBal = tmp;

    BigInt maxBal = metadata.myBal + metadata.otherBal;
    if (update.myBal + update.otherBal != maxBal) {
      throw const FormatException(
          "invalid parameter, destroying or creating money");
    }
    if (update.myBal < metadata.myBal) {
      throw const FormatException("invalid parameter, trying to take money");
    }
    if (update.round != metadata.round + BigInt.one) {
      throw const FormatException("invalid parameter, round not consecutive");
    }
    print("highway");
    // verify sig
    bool otherProposer = !metadata.isProposer;
    EthMetaData toTest = EthMetaData(
        id: metadata.id,
        us: metadata.us,
        other: metadata.other,
        myBal: update.myBal,
        otherBal: update.otherBal,
        isProposer: otherProposer,
        round: metadata.round + BigInt.one);
    // implicitly makes sure that the peer only signed round + 1

    Uint8List hash = keccak256(toTest.encode());
    Uint8List pk = ecRecover(
        hash,
        uint8ListToSig(
            update.signature)); // you can probably malleability attack this!
    if (publicKeyToAddress(pk) != metadata.other.addressBytes) {
      throw const FormatException("invalid parameter, invalid signature");
    }
    print("to");
    // Update state
    ChannelDB().updateMetaData(metadata);
    update.sender = PEER_SEND;
    addUpdate(update);
    _updateBalances(update.myBal, update.otherBal);
    print("hell");
  }

  Future<void> dispute() async {
    BigInt valueA;
    BigInt valueB;
    if (metadata.isProposer) {
      valueA = metadata.myBal;
      valueB = metadata.otherBal;
    } else {
      valueA = metadata.otherBal;
      valueB = metadata.myBal;
    }
    StateUpdate? last;
    for (StateUpdate update in history.reversed) {
      if (update.sender == PEER_SEND) {
        last = update;
        break;
      }
    }
    if (last == null) {
      throw Exception("No suitable state found");
    }
    
    String res = await contract.disputeChallenge(
        metadata.id, valueA, valueB, last.round, last.signature,
        credentials: wallet.privateKey);
  }

  // helper
  void _updateBalances(BigInt myBal, BigInt otherBal) {
    metadata.myBal = myBal;
    metadata.otherBal = otherBal;
  }
}

Uint8List randomID() {
  const size = 32;
  final random = Random.secure();
  Uint8List result = Uint8List(size);
  for (var i = 0; i < size; i++) {
    result[i] = random.nextInt(256);
  }
  return result;
}

MsgSignature uint8ListToSig(Uint8List list) {
  BigInt r = bytesToBigInt(list.sublist(0, 32));
  BigInt s = bytesToBigInt(list.sublist(32, 64));
  int v = list.elementAt(64);
  return MsgSignature(r, s, v);
}

/// Converts a [Uint8List] byte buffer into a [BigInt]
BigInt bytesToBigInt(Uint8List bytes) {
  BigInt result = BigInt.zero;
  for (final byte in bytes) {
    result = BigInt.from(byte) | (result << 8);
  }
  return result;
}
