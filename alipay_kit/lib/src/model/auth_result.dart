import 'dart:convert';

import 'package:alipay_kit/src/json/jser_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_result.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class AuthResult {
  const AuthResult({
    required this.success,
    this.resultCode,
    this.authCode,
    this.userId,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) =>
      _$AuthResultFromJson(json);

  @NullableStringToBoolConverter()
  final bool success;

  /// 200 业务处理成功，会返回authCode
  /// 1005 账户已冻结，如有疑问，请联系支付宝技术支持
  /// 202 系统异常，请稍后再试或联系支付宝技术支持
  @NullableStringToNullableIntConverter()
  final int? resultCode;

  final String? authCode;
  final String? userId;

  Map<String, dynamic> toJson() => _$AuthResultToJson(this);

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}
