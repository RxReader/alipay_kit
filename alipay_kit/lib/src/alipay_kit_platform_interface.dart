import 'package:alipay_kit/src/alipay_kit_method_channel.dart';
import 'package:alipay_kit/src/model/resp.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// 支付宝
///
/// * 默认不包含iOS支付
///   添加 alipay_kit_ios 依赖，可切换为不包含支付。
/// * 不含「iOS 支付」调用会抛出 [MissingPluginException]。
abstract class AlipayKitPlatform extends PlatformInterface {
  /// Constructs a AlipayKitPlatform.
  AlipayKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static AlipayKitPlatform _instance = MethodChannelAlipayKit();

  /// The default instance of [AlipayKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelAlipayKit].
  static AlipayKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AlipayKitPlatform] when
  /// they register themselves.
  static set instance(AlipayKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 支付
  Stream<AlipayResp> payResp() {
    throw UnimplementedError('payResp() has not been implemented.');
  }

  /// 登录
  Stream<AlipayResp> authResp() {
    throw UnimplementedError('authResp() has not been implemented.');
  }

  /// 检测支付宝是否已安装
  Future<bool> isInstalled() {
    throw UnimplementedError('isInstalled() has not been implemented.');
  }

  /// 支付
  Future<void> pay({
    required String orderInfo,
    bool isShowLoading = true,
    bool sandbox = false /// 沙箱模式
  }) {
    throw UnimplementedError(
        'pay({required orderInfo, isShowLoading}) has not been implemented.');
  }

  /// 登录
  Future<void> auth({
    required String authInfo,
    bool isShowLoading = true
  }) {
    throw UnimplementedError(
        'auth({required info, isShowLoading}) has not been implemented.');
  }


}
