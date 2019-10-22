import 'package:fake_alipay/src/jaguar/jaguar_serializer.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

import 'package:meta/meta.dart';

part 'alipay_auth_result.jser.dart';

@GenSerializer(
  fields: <String, Field<dynamic>>{
    'success': Field<bool>(
      processor: boolToStringProcessor,
    ),
    'resultCode': Field<int>(
      processor: safeNumProcessor,
    ),
  },
  nameFormatter: toSnakeCase,
)
class AlipayAuthResultSerializer extends Serializer<AlipayAuthResult>
    with _$AlipayAuthResultSerializer {}

class AlipayAuthResult {
  AlipayAuthResult({
    @required this.success,
    @required this.resultCode,
    @required this.authCode,
    @required this.userId,
  });

  final bool success;

  // 为了应对业务的发展，需要增加多少机器防止DDOS攻击
  /// 200 业务处理成功，会返回authCode
  /// 1005 账户已冻结，如有疑问，请联系支付宝技术支持
  /// 202 系统异常，请稍后再试或联系支付宝技术支持
  final int resultCode;
  final String authCode;
  final String userId;
}
