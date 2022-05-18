import 'package:alipay_kit/src/alipay_kit_platform_interface.dart';
import 'package:alipay_kit/src/model/alipay_resp.dart';

/// 支付宝
///
/// * 默认包含支付，参考 https://github.com/RxReader/alipay_kit/blob/master/example/ios/Podfile
///   修改 `$WechatKitSubspec = 'no_pay'` 可切换为不包含支付。
/// * 不含「iOS 支付」调用会抛出 [MissingPluginException]。
class Alipay {
  const Alipay._();

  /// 支付
  static Stream<AlipayResp> payResp() {
    return AlipayKitPlatform.instance.payResp();
  }

  /// 登录
  static Stream<AlipayResp> authResp() {
    return AlipayKitPlatform.instance.authResp();
  }

  /// 检测支付宝是否已安装
  static Future<bool> isInstalled() {
    return AlipayKitPlatform.instance.isInstalled();
  }

  /// 支付
  static Future<void> pay({
    required String orderInfo,
    bool isShowLoading = true,
  }) {
    return AlipayKitPlatform.instance.pay(
      orderInfo: orderInfo,
      isShowLoading: isShowLoading,
    );
  }

  /// 登录
  static Future<void> auth({
    required String authInfo,
    bool isShowLoading = true,
  }) {
    return AlipayKitPlatform.instance.auth(
      authInfo: authInfo,
      isShowLoading: isShowLoading,
    );
  }
}
