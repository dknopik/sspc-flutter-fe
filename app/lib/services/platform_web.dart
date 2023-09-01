import 'dart:html';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void dbSetup() {
  databaseFactory = databaseFactoryFfiWeb;
}

String loadFile(String filename) {
  return window.localStorage[filename]!;
}

void storeFile(String filename, String content) {
  window.localStorage[filename] = content;
}
