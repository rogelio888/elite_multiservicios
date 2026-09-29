import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

void main() {
  for (int i = 0; i < 1000000; i++) {
    String code = i.toString().padLeft(6, '0');
    var bytes = utf8.encode(code);
    var digest = sha256.convert(bytes);
    if (digest.toString() ==
        'f132abb8f9cb588e9cc1bbf9dde9affe08910c789705615e3a96c3a5f791d144') {
      stdout.writeln('FOUND: $code');
      return;
    }
  }
}
