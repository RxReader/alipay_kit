import 'package:fake_alipay/src/domain/alipay_auth_result.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:meta/meta.dart';

part 'alipay_resp.jser.dart';

@GenSerializer(
  fields: <String, Field<dynamic>>{
    'resultStatus': Field<int>(
      processor: safeNumProcessor,
    ),
  },
)
class AlipayRespSerializer extends Serializer<AlipayResp>
    with _$AlipayRespSerializer {}

class AlipayResp {
  AlipayResp({
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
  final int resultStatus;

  /// 支付后结果
  final String result;

  final String memo;

  AlipayAuthResult toAuthResult() {
    if (resultStatus == 9000) {
      if (result != null && result.isNotEmpty) {
        Map<String, String> params = Uri.parse(result).queryParameters;
        return AlipayAuthResultSerializer().fromMap(params);
      }
    }
    return null;
  }
}
