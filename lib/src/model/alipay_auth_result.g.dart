// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alipay_auth_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlipayAuthResult _$AlipayAuthResultFromJson(Map<String, dynamic> json) {
  return AlipayAuthResult(
    success: const NullableStringToBoolConverter()
        .fromJson(json['success'] as String?),
    resultCode: const NullableStringToNullableIntConverter()
        .fromJson(json['result_code'] as String?),
    authCode: json['auth_code'] as String?,
    userId: json['user_id'] as String?,
  );
}

Map<String, dynamic> _$AlipayAuthResultToJson(AlipayAuthResult instance) =>
    <String, dynamic>{
      'success': const NullableStringToBoolConverter().toJson(instance.success),
      'result_code': const NullableStringToNullableIntConverter()
          .toJson(instance.resultCode),
      'auth_code': instance.authCode,
      'user_id': instance.userId,
    };
