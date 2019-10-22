// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alipay_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AlipayRespSerializer implements Serializer<AlipayResp> {
  final SafeNumProcessor _safeNumProcessor = const SafeNumProcessor();
  @override
  Map<String, dynamic> toMap(AlipayResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret, 'resultStatus', _safeNumProcessor.serialize(model.resultStatus));
    setMapValue(ret, 'result', model.result);
    setMapValue(ret, 'memo', model.memo);
    return ret;
  }

  @override
  AlipayResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new AlipayResp(
        resultStatus:
            _safeNumProcessor.deserialize(map['resultStatus']) as int ??
                getJserDefault('resultStatus'),
        result: map['result'] as String ?? getJserDefault('result'),
        memo: map['memo'] as String ?? getJserDefault('memo'));
    return obj;
  }
}
