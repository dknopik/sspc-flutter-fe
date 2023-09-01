import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:app/services/ethereum_connect.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:web3dart/web3dart.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ChannelDB {

  late Database database;

  static final ChannelDB _instance = ChannelDB._internal();
 
  factory ChannelDB() {
    return _instance;
  }

  ChannelDB._internal() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    initDB();
  }

  void initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = join(await getDatabasesPath(), 'channel.db');
    print(path);
    database = await openDatabase(path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE channels(id BLOB PRIMARY KEY, us TEXT, other TEXT, myBal TEXT, otherBal TEXT, isProposer BOOLEAN, round TEXT)',
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
}


