import 'package:alipay_kit/src/alipay_kit_method_channel.dart';
import 'package:alipay_kit/src/model/alipay_resp.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

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

  Stream<AlipayResp> payResp() {
    throw UnimplementedError('payResp() has not been implemented.');
  }

  Stream<AlipayResp> authResp() {
    throw UnimplementedError('authResp() has not been implemented.');
  }

  Future<bool> isInstalled() {
    throw UnimplementedError('isInstalled() has not been implemented.');
  }

  Future<void> pay({
    required String orderInfo,
    bool isShowLoading = true,
  }) {
    throw UnimplementedError('pay({required orderInfo, isShowLoading}) has not been implemented.');
  }

  Future<void> auth({
    required String authInfo,
    bool isShowLoading = true,
  }) {
    throw UnimplementedError('auth({required info, isShowLoading}) has not been implemented.');
  }
}
