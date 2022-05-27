import 'package:alipay_kit/src/alipay_kit_platform_interface.dart';

/// 支付宝
///
/// * 默认不包含iOS支付
///   添加 alipay_kit_ios 依赖，可切换为不包含支付。
/// * 不含「iOS 支付」调用会抛出 [MissingPluginException]。
class Alipay {
  const Alipay._();

  static AlipayKitPlatform get instance => AlipayKitPlatform.instance;
}
