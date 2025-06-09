import 'dart:convert';
import 'dart:typed_data';

class Utility {
  static String uint8ListToBase64String(Uint8List data) {
    return base64Encode(data);
  }

  static Uint8List base64StringToUint8List(String base64String) {
    return base64Decode(base64String);
  }
}
