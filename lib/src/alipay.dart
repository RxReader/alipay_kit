import 'dart:async';

import 'package:alipay_kit/src/model/alipay_resp.dart';
import 'package:flutter/services.dart';

///
class Alipay {
  ///
  Alipay._();

  static Alipay get instance => _instance;

  static final Alipay _instance = Alipay._();

  static const String _METHOD_ISINSTALLED = 'isInstalled';
  static const String _METHOD_PAY = 'pay';
  static const String _METHOD_AUTH = 'auth';

  static const String _METHOD_ONPAYRESP = 'onPayResp';
  static const String _METHOD_ONAUTHRESP = 'onAuthResp';

  static const String _ARGUMENT_KEY_ORDERINFO = 'orderInfo';
  static const String _ARGUMENT_KEY_AUTHINFO = 'authInfo';
  static const String _ARGUMENT_KEY_ISSHOWLOADING = 'isShowLoading';

  late final MethodChannel _channel =
      const MethodChannel('v7lin.github.io/alipay_kit')
        ..setMethodCallHandler(_handleMethod);

  final StreamController<AlipayResp> _payRespStreamController =
      StreamController<AlipayResp>.broadcast();
  final StreamController<AlipayResp> _authRespStreamController =
      StreamController<AlipayResp>.broadcast();

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case _METHOD_ONPAYRESP:
        _payRespStreamController.add(AlipayResp.fromJson(
            (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>()));
        break;
      case _METHOD_ONAUTHRESP:
        _authRespStreamController.add(AlipayResp.fromJson(
            (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>()));
        break;
    }
  }

  /// 支付
  Stream<AlipayResp> payResp() {
    return _payRespStreamController.stream;
  }

  /// 登录
  Stream<AlipayResp> authResp() {
    return _authRespStreamController.stream;
  }

  /// 检测支付宝是否已安装 - x.y.z-Android-Only 版本下 iOS 调用会直接抛出异常 No implementation [MissingPluginException]
  Future<bool> isInstalled() async {
    return await _channel.invokeMethod<bool?>(_METHOD_ISINSTALLED) ?? false;
  }

  /// 支付 - x.y.z-Android-Only 版本下 iOS 调用会直接抛出异常 No implementation [MissingPluginException]
  Future<void> pay({
    required String orderInfo,
    bool isShowLoading = true,
  }) {
    return _channel.invokeMethod<void>(
      _METHOD_PAY,
      <String, dynamic>{
        _ARGUMENT_KEY_ORDERINFO: orderInfo,
        _ARGUMENT_KEY_ISSHOWLOADING: isShowLoading,
      },
    );
  }

  /// 登录 - x.y.z-Android-Only 版本下 iOS 调用会直接抛出异常 No implementation [MissingPluginException]
  Future<void> auth({
    required String info,
    bool isShowLoading = true,
  }) {
    return _channel.invokeMethod<void>(
      _METHOD_AUTH,
      <String, dynamic>{
        _ARGUMENT_KEY_AUTHINFO: info,
        _ARGUMENT_KEY_ISSHOWLOADING: isShowLoading,
      },
    );
  }
}
