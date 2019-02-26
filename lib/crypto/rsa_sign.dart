import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:fake_alipay/crypto/asn1.dart';
import 'package:fake_alipay/crypto/pem.dart';
import 'package:fake_alipay/crypto/rsa.dart';

class RSASigner {
  final RSAPrivateKey _rsaKey;
  final Converter _converter;
  final Uint8List _digestIdentifier;

  RSASigner(this._rsaKey, this._converter, this._digestIdentifier);

  List<int> sign(List<int> bytes) {
    var digest = _digestInfo(_converter.convert(bytes).bytes, _digestIdentifier);
    var modulusLen = (_rsaKey.bitLength + 7) ~/ 8;

    var block = Uint8List(modulusLen);
    var padLength = block.length - digest.length - 3;
    block[0] = 0x00;
    block[1] = 0x01;
    block.fillRange(2, 2 + padLength, 0xFF);
    block[2 + padLength] = 0x00;
    block.setRange(2 + padLength + 1, block.length, digest);
    return RSAAlgorithm.encrypt(_rsaKey, block, modulusLen);
  }

  Uint8List _digestInfo(Uint8List hash, Uint8List digestIdentifier) {
    var out = Uint8List(2 + 2 + digestIdentifier.length + 2 + 2 + hash.length);
    var i = 0;

    // header
    out[i++] = ASN1Parser.SEQUENCE_TAG;
    out[i++] = out.length-2;

    // algorithmIdentifier.header
    out[i++] = ASN1Parser.SEQUENCE_TAG;
    out[i++] = digestIdentifier.length+2;

    // algorithmIdentifier.bytes
    out.setAll(i, digestIdentifier);
    i += digestIdentifier.length;

    // algorithmIdentifier.null
    out[i++] = ASN1Parser.NULL_TAG;
    out[i++] = 0;

    // hash.header
    out[i++] = ASN1Parser.OCTET_STRING_TAG;
    out[i++] = hash.length;

    // hash.bytes
    out.setAll(i, hash);

    return out;
  }

  /// Digest        Digest Identifier Hex String
  /// MD2           06082a864886f70d0202
  /// MD4           06082a864886f70d0204
  /// MD5           06082a864886f70d0205
  /// RIPEMD-128    06052b24030202
  /// RIPEMD-160    06052b24030201
  /// RIPEMD-256    06052b24030203
  /// SHA-1         06052b0e03021a
  /// SHA-224       0609608648016503040204
  /// SHA-256       0609608648016503040201
  /// SHA-384       0609608648016503040202
  /// SHA-512       0609608648016503040203

  static RSASigner sha1Rsa(String pem) {
    RSAPrivateKey rsaKey = keyFromString(pem);
    return RSASigner(rsaKey, sha1, hex.decode('06052b0e03021a'));
  }

  static RSASigner sha256Rsa(String pem) {
    RSAPrivateKey rsaKey = keyFromString(pem);
    return RSASigner(rsaKey, sha256, hex.decode('0609608648016503040201'));
  }
}
