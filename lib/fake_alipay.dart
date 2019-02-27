import 'dart:async';
import 'dart:convert';

import 'package:fake_alipay/crypto/rsa.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class FakeAlipayErrorCode {
  FakeAlipayErrorCode._();

  static const int SUCCESS = 9000;
  static const int CHECK = 8000;
  static const int FAILURE = 4000;
  static const int REPEAT_REQUEST = 5000;
  static const int CANCLE = 6001;
  static const int NETWORK_ERROR = 6002;
}

class FakeAlipayAuthResult {
  FakeAlipayAuthResult._(
    this.success,
    this.resultCode,
    this.authCode,
    this.userId,
  );

  final bool success;

  /// 200 业务处理成功，会返回authCode
  /// 1005 账户已冻结，如有疑问，请联系支付宝技术支持
  /// 202 系统异常，请稍后再试或联系支付宝技术支持
  final String resultCode;
  final String authCode;
  final String userId;
}

class FakeAlipayResp {
  FakeAlipayResp._({
    @required this.resultStatus,
    this.result,
    this.memo,
  });

  /// 支付状态，参考支付宝的文档https://docs.open.alipay.com/204/105695/
  /// 返回码，标识支付状态，含义如下：
  /// 9000——订单支付成功         下面的result有值
  /// 8000——正在处理中
  /// 4000——订单支付失败
  /// 5000——重复请求
  /// 6001——用户中途取消
  /// 6002——网络连接出错
  final String resultStatus;

  /// 支付后结果
  final String result;

  final String memo;

  FakeAlipayAuthResult toAuthResult() {
    if ('${FakeAlipayErrorCode.SUCCESS}' == resultStatus) {
      Map<String, String> params = Uri.parse(result).queryParameters;
      String success = params['success'];
      String resultCode = params['result_code'];
      String authCode = params['auth_code'];
      String userId = params['user_id'];
      return FakeAlipayAuthResult._(
        success == true.toString(),
        resultCode,
        authCode,
        userId,
      );
    }
    return null;
  }
}

class FakeAlipay {
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

  static const int PRIVATEKEY_RSA2_MIN_LENGTH = 2048;

  static const MethodChannel _channel =
      MethodChannel('v7lin.github.io/fake_alipay');

  final StreamController<FakeAlipayResp> _payRespStreamController =
      StreamController<FakeAlipayResp>.broadcast();
  final StreamController<FakeAlipayResp> _authRespStreamController =
      StreamController<FakeAlipayResp>.broadcast();

  Future<void> registerApp() async {
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case _METHOD_ONPAYRESP:
        _payRespStreamController.add(_toAlipayResp(call.arguments));
        break;
      case _METHOD_ONAUTHRESP:
        _authRespStreamController.add(_toAlipayResp(call.arguments));
        break;
    }
  }

  FakeAlipayResp _toAlipayResp(dynamic arguments) {
    return FakeAlipayResp._(
      resultStatus: arguments['resultStatus'] as String,
      result: arguments['result'] as String,
      memo: arguments['mono'] as String,
    );
  }

  Stream<FakeAlipayResp> payResp() {
    return _payRespStreamController.stream;
  }

  Stream<FakeAlipayResp> authResp() {
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
            privateKey.length >= PRIVATEKEY_RSA2_MIN_LENGTH));
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
            privateKey.length >= PRIVATEKEY_RSA2_MIN_LENGTH));

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
            privateKey.length >= PRIVATEKEY_RSA2_MIN_LENGTH));

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

class FakeAlipayProvider extends InheritedWidget {
  FakeAlipayProvider({
    Key key,
    @required this.alipay,
    @required Widget child,
  }) : super(key: key, child: child);

  final FakeAlipay alipay;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    FakeAlipayProvider oldProvider = oldWidget as FakeAlipayProvider;
    return alipay != oldProvider.alipay;
  }

  static FakeAlipayProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(FakeAlipayProvider)
        as FakeAlipayProvider;
  }
}
