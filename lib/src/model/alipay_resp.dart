import 'package:alipay_kit/src/json/jser_converter.dart';
import 'package:alipay_kit/src/model/alipay_auth_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alipay_resp.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class AlipayResp {
  AlipayResp({
    this.resultStatus,
    this.result,
    this.memo,
  });

  factory AlipayResp.fromJson(Map<String, dynamic> json) =>
      _$AlipayRespFromJson(json);

  /// 支付状态，参考支付宝的文档https://docs.open.alipay.com/204/105695/
  /// 返回码，标识支付状态，含义如下：
  /// 9000——订单支付成功         下面的result有值
  /// 8000——正在处理中
  /// 4000——订单支付失败
  /// 5000——重复请求
  /// 6001——用户中途取消
  /// 6002——网络连接出错
  @NullableStringToNullableIntConverter()
  final int? resultStatus;

  /// 支付后结果
  final String? result;

  final String? memo;

  bool get isSuccessful => resultStatus == 9000;

  bool get isCancelled => resultStatus == 6001;

  AlipayAuthResult? parseAuthResult() {
    if (isSuccessful) {
      if (result?.isNotEmpty ?? false) {
        final Map<String, String> params =
            Uri.parse('alipay://alipay?$result').queryParameters;
        return AlipayAuthResult.fromJson(params);
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() => _$AlipayRespToJson(this);
}
