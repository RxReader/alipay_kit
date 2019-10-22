// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alipay_auth_result.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlipayAuthResultSerializer
    implements Serializer<AlipayAuthResult> {
  final BoolToStringProcessor _boolToStringProcessor = const BoolToStringProcessor();
  final SafeNumProcessor _safeNumProcessor = const SafeNumProcessor();
  @override
  Map<String, dynamic> toMap(AlipayAuthResult model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret, 'success', _boolToStringProcessor.serialize(model.success));
    setMapValue(
        ret, 'result_code', _safeNumProcessor.serialize(model.resultCode));
    setMapValue(ret, 'auth_code', model.authCode);
    setMapValue(ret, 'user_id', model.userId);
    return ret;
  }

  @override
  AlipayAuthResult fromMap(Map map) {
    if (map == null) return null;
    final obj = new AlipayAuthResult(
        success: _boolToStringProcessor.deserialize(map['success'] as String) ??
            getJserDefault('success'),
        resultCode: _safeNumProcessor.deserialize(map['result_code']) as int ??
            getJserDefault('resultCode'),
        authCode: map['auth_code'] as String ?? getJserDefault('authCode'),
        userId: map['user_id'] as String ?? getJserDefault('userId'));
    return obj;
  }
}
