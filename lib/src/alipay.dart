import 'package:alipay_kit/src/alipay_kit_platform_interface.dart';
import 'package:alipay_kit/src/model/alipay_resp.dart';

/// 支付宝
///
/// * 默认包含支付，参考 https://github.com/RxReader/alipay_kit/blob/master/example/ios/Podfile
///   修改 `$AlipayKitSubspec = 'bdr'` 可切换为不包含支付。
/// * 不含「iOS 支付」调用会抛出 [MissingPluginException]。
class Alipay {
  const Alipay._();

  static AlipayKitPlatform get instance => AlipayKitPlatform.instance;
}
