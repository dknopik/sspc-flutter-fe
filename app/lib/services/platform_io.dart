import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void dbSetup() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

String loadFile(String filename) {
  return File(filename).readAsStringSync();
}

void storeFile(String filename, String content) {
  File(filename).writeAsString(content);
}