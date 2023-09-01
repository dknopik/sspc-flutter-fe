

import 'dart:convert';

import 'package:app/services/network.dart';

final Codec<dynamic, String> linkEncoding = json.fuse(utf8.fuse(base64Url));

NetworkMessage? fromLink(Uri uri) {
  if (uri.hasFragment) {
    try {
      final fragmentJson = linkEncoding.decode(uri.fragment.substring(1));
      return NetworkMessage.fromJson(json.decode(fragmentJson));
    } catch (e) {
      return null;
    }
  }
  return null;
}

String toLink(NetworkMessage msg) {
  return "https://sspc.dknopik.de/#${linkEncoding.encode(msg.toJson())}";
}