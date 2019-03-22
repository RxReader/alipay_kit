import 'package:fake_alipay/fake_alipay.dart';
import 'package:fake_alipay/src/domain/alipay_resp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

void main() {
  test('smoke test - snake case', () {
    print('${toSnakeCase('oneField')}');
    print('${toSnakeCase('oneField_street')}');
    print('${toSnakeCase('one_field')}');
  });

  test('smoke test - kebab case', () {
    print('${toKebabCase('oneField')}');
    print('${toKebabCase('oneField_street')}');
    print('${toKebabCase('one_field')}');
  });

  test('smoke test - camel case', () {
    print('${toCamelCase('oneField')}');
    print('${toCamelCase('oneField_street')}');
    print('${toCamelCase('one_field')}');
  });

  test('smoke test - jaguar_serializer', () {
    Map<String, String> result = <String, String>{
      'resultStatus': '9000',
      'memo': '处理成功',
      'result':
          'success=true&auth_code=d9d1b5acc26e461dbfcb6974c8ff5E64&result_code=200&user_id=2088003646494707',
    };

    AlipayResp resp = AlipayRespSerializer().fromMap(result);
    print('${resp.resultStatus} - ${resp.memo} - ${resp.result}');
    expect(resp.resultStatus, equals(9000));

    AlipayAuthResult authResult = resp.parseAuthResult();
    print(
        '${authResult.success} - ${authResult.resultCode} - ${authResult.authCode} - ${authResult.userId}');
    expect(authResult.success, equals(true));
    expect(authResult.resultCode, equals(200));
  });
}
