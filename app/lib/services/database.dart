import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:app/services/ethereum_connect.dart';
import 'package:app/services/platform.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:web3dart/web3dart.dart';

class ChannelDB {

  late Database database;

  static final ChannelDB _instance = ChannelDB._internal();
 
  factory ChannelDB() {
    return _instance;
  }

  ChannelDB._internal() {
    initDB();
  }

  Future<void> initDB() async {
    dbSetup();
    WidgetsFlutterBinding.ensureInitialized();
    String fullPath;
    const path = "channel.db";
    try {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      fullPath = "${appDocDirectory.path}/$path";
    } catch(e) {
      fullPath = path;
    }
    print(fullPath);
    database = await openDatabase(fullPath,
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE updates(id INTEGER PRIMARY KEY AUTOINCREMENT, channelID BLOB, myBal TEXT, otherBal TEXT, round TEXT, sender BOOLEAN, signature BLOB)");
        return db.execute(
          "CREATE TABLE channels(id BLOB PRIMARY KEY, us TEXT, other TEXT, myBal TEXT, otherBal TEXT, isProposer BOOLEAN, round TEXT)"
        );
      },
      version: 1,
    );
  }

  Future<void> insertMetaData(EthMetaData metadata) async {
    await database.insert('channels', metadata.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<List<EthMetaData>> getMetaData() async {
    final List<Map<String, dynamic>> maps = await database.query('channels');
    int entries = maps.length;
    print("Read $entries from database");
    return List.generate(maps.length, (i) {
      bool proposer = false;
      if (maps[i]['isProposer'] == 1) {
        proposer = true;
      }

      return EthMetaData(
        id: maps[i]['id'],
        us: EthereumAddress.fromHex(maps[i]['us']),
        other: EthereumAddress.fromHex(maps[i]['other']),
        myBal: BigInt.parse(maps[i]['myBal']),
        otherBal: BigInt.parse(maps[i]['otherBal']),
        isProposer: proposer,
        round: BigInt.parse(maps[i]['round']),
      );
    });
  }

  Future<void> updateMetaData(EthMetaData data) async {
    await database.update(
      'channels',
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }
  
  Future<void> insertStateUpdate(StateUpdate update) async {
    await database.insert('updates', update.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<List<ChannelObj>> getChannels(MyWallet wallet) async {
    final list = List<ChannelObj>.empty(growable: true);
    final metaDataList = await getMetaData();
    for (final metadata in metaDataList) {
      // Only update unknown channels
      if (wallet.channels.any((element) => element.metadata.id == metadata.id)) {
        continue;
      }

      final updates = await getStateUpdatesByID(metadata.id);

      ChannelObj obj = wallet.createNewChannel();
      obj.metadata = metadata;
      obj.history = updates;
    }
    return list;
  }

  Future<List<StateUpdate>> getStateUpdatesByID(Uint8List id) async {
    final List<Map<String, dynamic>> maps = await database.query('updates', where: 'channelID = ?', whereArgs: [id]);
    int entries = maps.length;
    print("Read $entries from state update database");
    return List.generate(maps.length, (i) {
      bool sender = false;
      if (maps[i]['sender'] == 1) {
        sender = true;
      }

      return StateUpdate(
        id: maps[i]['channelID'],
        myBal: BigInt.parse(maps[i]['myBal']),
        otherBal: BigInt.parse(maps[i]['otherBal']),
        sender: sender,
        round: BigInt.parse(maps[i]['round']),
        signature: maps[i]['signature'],
      );
    });
  }
}


