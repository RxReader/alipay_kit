import 'dart:convert';

import 'package:alipay_kit/alipay_kit.dart';
import 'package:alipay_kit_example/crypto/rsa.dart';

extension UnsafeAlipay on Alipay {
  static const String SIGNTYPE_RSA = 'RSA';
  static const String SIGNTYPE_RSA2 = 'RSA2';

  static const String AUTHTYPE_AUTHACCOUNT = 'AUTHACCOUNT';
  static const String AUTHTYPE_LOGIN = 'LOGIN';

  /// 支付
  Future<void> unsafePay({
    required Map<String, dynamic> orderInfo,
    String signType = SIGNTYPE_RSA2,
    required String privateKey,
    bool isShowLoading = true,
  }) {
    final String? charset = orderInfo['charset'] as String?;
    final Encoding encoding = Encoding.getByName(charset) ?? utf8;
    final Map<String, dynamic> clone = <String, dynamic>{
      ...orderInfo,
      'sign_type': signType,
    };
    final String param = _param(clone, encoding);
    final String sign = _sign(clone, signType, privateKey);
    return pay(
      orderInfo:
          '$param&sign=${Uri.encodeQueryComponent(sign, encoding: encoding)}',
      isShowLoading: isShowLoading,
    );
  }

  /// 登录
  Future<void> unsafeAuth({
    required String appId, // 支付宝分配给开发者的应用ID
    required String pid, // 签约的支付宝账号对应的支付宝唯一用户号，以2088开头的16位纯数字组成
    required String targetId, // 商户标识该次用户授权请求的ID，该值在商户端应保持唯一
    String authType =
        AUTHTYPE_AUTHACCOUNT, // 标识授权类型，取值范围：AUTHACCOUNT 代表授权；LOGIN 代表登录
    String signType =
        SIGNTYPE_RSA2, // 商户生成签名字符串所使用的签名算法类型，目前支持 RSA2 和 RSA ，推荐使用 RSA2
    required String privateKey,
    bool isShowLoading = true,
  }) {
    assert(authType == AUTHTYPE_AUTHACCOUNT || authType == AUTHTYPE_LOGIN);
    final Map<String, dynamic> authInfo = <String, dynamic>{
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
    authInfo['sign_type'] = signType;
    const Encoding encoding = utf8; // utf-8
    final String param = _param(authInfo, encoding);
    final String sign = _sign(authInfo, signType, privateKey);
    return auth(
      info: '$param&sign=${Uri.encodeQueryComponent(sign, encoding: encoding)}',
      isShowLoading: isShowLoading,
    );
  }

  String _param(Map<String, dynamic> map, Encoding encoding) {
    return map.entries
        .map((MapEntry<String, dynamic> e) =>
            '${e.key}=${Uri.encodeQueryComponent('${e.value}', encoding: encoding)}')
        .join('&');
  }

  String _sign(Map<String, dynamic> map, String signType, String privateKey) {
    // 参数排序
    final List<String> keys = map.keys.toList();
    keys.sort();
    final String content = keys.map((String e) => '$e=${map[e]}').join('&');
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
