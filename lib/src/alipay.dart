import 'dart:async';
import 'dart:convert';

import 'package:fake_alipay/src/domain/alipay_resp.dart';
import 'package:fake_crypto/fake_crypto.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class Alipay {
  static const String _METHOD_ISALIPAYINSTALLED = 'isAlipayInstalled';
  static const String _METHOD_PAY = 'pay';
  static const String _METHOD_AUTH = 'auth';

  static const String _METHOD_ONPAYRESP = 'onPayResp';
  static const String _METHOD_ONAUTHRESP = 'onAuthResp';

  static const String _ARGUMENT_KEY_ORDERINFO = 'orderInfo';
  static const String _ARGUMENT_KEY_AUTHINFO = 'authInfo';
  static const String _ARGUMENT_KEY_ISSHOWLOADING = 'isShowLoading';

  static const String SIGNTYPE_RSA = 'RSA';
  static const String SIGNTYPE_RSA2 = 'RSA2';

  static const String AUTHTYPE_AUTHACCOUNT = 'AUTHACCOUNT';
  static const String AUTHTYPE_LOGIN = 'LOGIN';

  static const int _PRIVATEKEY_RSA2_MIN_LENGTH = 2048;

  final MethodChannel _channel =
      const MethodChannel('v7lin.github.io/fake_alipay');

  final StreamController<AlipayResp> _payRespStreamController =
      StreamController<AlipayResp>.broadcast();
  final StreamController<AlipayResp> _authRespStreamController =
      StreamController<AlipayResp>.broadcast();

  Future<void> registerApp() async {
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case _METHOD_ONPAYRESP:
        _payRespStreamController.add(AlipayRespSerializer()
            .fromMap(call.arguments as Map<dynamic, dynamic>));
        break;
      case _METHOD_ONAUTHRESP:
        _authRespStreamController.add(AlipayRespSerializer()
            .fromMap(call.arguments as Map<dynamic, dynamic>));
        break;
    }
  }

  Stream<AlipayResp> payResp() {
    return _payRespStreamController.stream;
  }

  Stream<AlipayResp> authResp() {
    return _authRespStreamController.stream;
  }

  Future<bool> isAlipayInstalled() async {
    return (await _channel.invokeMethod(_METHOD_ISALIPAYINSTALLED)) as bool;
  }

  Future<void> payOrderJson({
    @required String orderInfo,
    String signType = SIGNTYPE_RSA2,
    @required String privateKey,
    bool isShowLoading = true,
  }) {
    assert(orderInfo != null && orderInfo.isNotEmpty);
    assert((signType == SIGNTYPE_RSA &&
            privateKey != null &&
            privateKey.isNotEmpty) ||
        (signType == SIGNTYPE_RSA2 &&
            privateKey != null &&
            privateKey.length >= _PRIVATEKEY_RSA2_MIN_LENGTH));

    return payOrderMap(
      orderInfo: json.decode(orderInfo) as Map<String, String>,
      signType: signType,
      privateKey: privateKey,
      isShowLoading: isShowLoading,
    );
  }

  Future<void> payOrderMap({
    @required Map<String, String> orderInfo,
    String signType = SIGNTYPE_RSA2,
    @required String privateKey,
    bool isShowLoading = true,
  }) {
    assert(orderInfo != null && orderInfo.isNotEmpty);
    assert((signType == SIGNTYPE_RSA &&
            privateKey != null &&
            privateKey.isNotEmpty) ||
        (signType == SIGNTYPE_RSA2 &&
            privateKey != null &&
            privateKey.length >= _PRIVATEKEY_RSA2_MIN_LENGTH));

    orderInfo.putIfAbsent('sign_type', () => signType);

    String charset = orderInfo['charset'];
    Encoding encoding;
    if (charset != null && charset.isNotEmpty) {
      encoding = Encoding.getByName(charset);
    }
    if (encoding == null) {
      encoding = utf8;
    }

    String param = _param(orderInfo, encoding);
    String sign = _sign(orderInfo, signType, privateKey);

    return payOrderSign(
      orderInfo:
          '$param&sign=${Uri.encodeQueryComponent(sign, encoding: encoding)}',
      isShowLoading: isShowLoading,
    );
  }

  Future<void> payOrderSign({
    @required String orderInfo,
    bool isShowLoading = true,
  }) {
    assert(orderInfo != null && orderInfo.isNotEmpty);

    return _channel.invokeMethod(
      _METHOD_PAY,
      <String, dynamic>{
        _ARGUMENT_KEY_ORDERINFO: orderInfo,
        _ARGUMENT_KEY_ISSHOWLOADING: isShowLoading,
      },
    );
  }

  Future<void> auth({
    @required String appId, // 支付宝分配给开发者的应用ID
    @required String pid, // 签约的支付宝账号对应的支付宝唯一用户号，以2088开头的16位纯数字组成
    @required String targetId, // 商户标识该次用户授权请求的ID，该值在商户端应保持唯一
    String authType =
        AUTHTYPE_AUTHACCOUNT, // 标识授权类型，取值范围：AUTHACCOUNT 代表授权；LOGIN 代表登录
    String signType =
        SIGNTYPE_RSA2, // 商户生成签名字符串所使用的签名算法类型，目前支持 RSA2 和 RSA ，推荐使用 RSA2
    @required String privateKey,
    bool isShowLoading = true,
  }) {
    assert(appId != null && appId.isNotEmpty && appId.length <= 16);
    assert(pid != null && pid.isNotEmpty && pid.length <= 16);
    assert(targetId != null && targetId.isNotEmpty && targetId.length <= 32);
    assert(authType == AUTHTYPE_AUTHACCOUNT || authType == AUTHTYPE_LOGIN);
    assert((signType == SIGNTYPE_RSA &&
            privateKey != null &&
            privateKey.isNotEmpty) ||
        (signType == SIGNTYPE_RSA2 &&
            privateKey != null &&
            privateKey.length >= _PRIVATEKEY_RSA2_MIN_LENGTH));

    Map<String, String> authInfo = <String, String>{
      'apiname': 'com.alipay.account.auth',
      'method': 'alipay.open.auth.sdk.code.get',
      'app_id': appId,
      'app_name': 'mc',
      'biz_type': 'openservice',
      'pid': pid,
      'product_id': 'APP_FAST_LOGIN',
      'scope': 'kuaijie',
      'target_id': targetId,
      'auth_type': authType,
    };

    authInfo.putIfAbsent('sign_type', () => signType);

    // utf-8
    Encoding encoding = utf8;

    String param = _param(authInfo, encoding);
    String sign = _sign(authInfo, signType, privateKey);

    return authSign(
      info: '$param&sign=${Uri.encodeQueryComponent(sign, encoding: encoding)}',
      isShowLoading: isShowLoading,
    );
  }

  Future<void> authSign({
    @required String info,
    bool isShowLoading = true,
  }) {
    assert(info != null && info.isNotEmpty);

    return _channel.invokeMethod(
      _METHOD_AUTH,
      <String, dynamic>{
        _ARGUMENT_KEY_AUTHINFO: info,
        _ARGUMENT_KEY_ISSHOWLOADING: isShowLoading,
      },
    );
  }

  String _param(Map<String, String> map, Encoding encoding) {
    List<String> keys = map.keys.toList();
    return List<String>.generate(keys.length, (int index) {
      String key = keys[index];
      String value = map[key];
      return '$key=${Uri.encodeQueryComponent(value, encoding: encoding)}';
    }).join('&');
  }

  String _sign(Map<String, String> map, String signType, String privateKey) {
    /// 参数排序
    List<String> keys = map.keys.toList();
    keys.sort();
    String content = List<String>.generate(keys.length, (int index) {
      String key = keys[index];
      String value = map[key];
      return '$key=$value';
    }).join('&');
    String sign;
    switch (signType) {
      case SIGNTYPE_RSA:
        sign = base64
            .encode(RsaSigner.sha1Rsa(privateKey).sign(utf8.encode(content)));
        break;
      case SIGNTYPE_RSA2:
        sign = base64
            .encode(RsaSigner.sha256Rsa(privateKey).sign(utf8.encode(content)));
        break;
      default:
        throw UnsupportedError('Alipay sign_type($signType) is not supported!');
    }
    return sign;
  }
}
