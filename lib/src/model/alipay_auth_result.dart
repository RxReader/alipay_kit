import 'package:alipay_kit/src/json/jser_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alipay_auth_result.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class AlipayAuthResult {
  AlipayAuthResult({
    required this.success,
    this.resultCode,
    this.authCode,
    this.userId,
  });

  factory AlipayAuthResult.fromJson(Map<String, dynamic> json) =>
      _$AlipayAuthResultFromJson(json);

  @NullableStringToBoolConverter()
  final bool success;

  /// 200 业务处理成功，会返回authCode
  /// 1005 账户已冻结，如有疑问，请联系支付宝技术支持
  /// 202 系统异常，请稍后再试或联系支付宝技术支持
  @NullableStringToNullableIntConverter()
  final int? resultCode;

  final String? authCode;
  final String? userId;

  Map<String, dynamic> toJson() => _$AlipayAuthResultToJson(this);
}
