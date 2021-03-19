import 'dart:async';
import 'dart:convert';

import 'package:alipay_kit/alipay_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pedantic/pedantic.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const String MOCK_PRIVATE_KEY =
      '-----BEGIN PRIVATE KEY-----\n${'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC4/zzSLKzKd1te6zqAXU82222VhqVL1gr8YvJ6iIRc7Vx8l6rX1OyDswoPS8niqSXT/DxgAMvEJ8y231kEGTD2v14Q7c6Qqn4lHvU5edEiMU9exug9yJJuM+7X8mJ7tqP9cwd2XGo4NNaXDw7kWx5tudfY4iYoVpcK3ytnErmw2sgDWPua+8zbCuJRFjQ9ptMbn9mcXC6ixiG33woT7sKH1U1k4eb879GhiSdfDDPqnG1ChFCZRtb5MrQL792NJ+9j6dhcAI0FTi9euSR5W8PV79u4JukZca5GUgAxza2VyyLZkc0Ks/ygPK+RZL1VQyr8IsRaFUxZql3L25TYyqg9AgMBAAECggEAQsaexZ6qoEqFCLYP39XOihaab6ayc7VHMeLlc6VjYcer4q08Vbvdw4wUzYCl1tMHfIVHpb+jzaIwGrJ0By6wpeBdq+6q6T0hW3TZP23hN15lL+jMW8DSWkUUqY4sTkuW1h13TBn/nVo1O0GMNpFNYn36k6bN7zGSQ7JakFIKBPPUxnNgrwyf7T/oXTFBL6qrWYhDHwsFbTQX2UuLiF7+I4bJhDuZt39b31/h6EqzeVi9b31OEmpMKojPBDv2VzZ5Wun2SO9bBeiiSSUIuiU1sgOWBPEB6O5TMttNvmyA8GQa4HiTlYMz/rkmwwwgdfh4T/lSiDV9+Vd63xRj8eKqYQKBgQD+dzpZV7cILAp7XtUh6axaZR8iuzYjjnpaQmxCrBBCfl16lgCmJhspvxHZnZgurLL96JeU6hYtGck3VDpxPKVtSHPybxQwEysK236B2V6AEwLkVKEHB03g35FxHYo14x0mjUkfF7Q8NrmnPtELmYv7Z03OZHkFlWSSg12Jgc6fvwKBgQC6HMiWorPapzYwyD+H4si+yuUtO+YEPMvatN7bnymppuSt5RL4FVNdL02lzL6bUVhvsfDqQ6kws/wKYpLwTksYNkM9P14UKqFzy5zKSOr/zx5mXwgaaOJ7DnZx4outaFgntW8pQGjWHxbBX3H6mydRbVYaN6qUsjTHqaL6kCN3AwKBgQC9QSOOayRf2ZF6LA/MByT+nhLIHACp9T+efaRS+fGl4qHXmFSnPdQZ+ldmSEV1AVCmcyS5xlfz9yemFOjaa0aFvsstVdvn3Xm3u4OdQ3N7Qah29VJGDfKn+t8LB/NRHLcDgzUNAO41kmYFszx6qhpoQm6lwCgaNP/1z+nzaS2ptQKBgGyRk/ZD7bV06+jjOCR2CHM8exq7IYCBUs4/yu3FWJGOOUK0Ki+siRgIGzzIRrzmZDesTwTp+Y3ewP3x6RPkKGx0Yx8cky4ifFLHiax7gxM9aNeBQoHdg5kTo8blyGOdRifL8I/Y8g9OzYB6xEvULMiUhrD+njTmDGIZNGkEopuvAoGAXE+WA8GxSruKR9SziyaZxnGB1ggTDOT5qe8eeQnFpsfxU4ZAICrWB7Glezy0YyOXpRIxluUYjQdMkDQBz8913r/eYFdGw68z3iQY1xMkXMcy7ikeZ/VZjkQHVwbUplDH4ESGPoUjE32MHzRX9oiQkyWFK4x0qFu9gdYKb1tRTLw='}\n-----END PRIVATE KEY-----';

  const MethodChannel channel = MethodChannel('v7lin.github.io/alipay_kit');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'isInstalled':
          return true;
        case 'pay':
          unawaited(channel.binaryMessenger.handlePlatformMessage(
            channel.name,
            channel.codec.encodeMethodCall(MethodCall(
                'onPayResp',
                json.decode(
                    '{"resultStatus":"6001","result":"","memo":"支付未完成。"}'))),
            (ByteData? data) {
              // mock success
            },
          ));
          return null;
        case 'auth':
          throw PlatformException(code: '0', message: '懒得去mock');
      }
      throw PlatformException(code: '0', message: '想啥呢，升级插件不想升级Mock？');
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('isInstalled', () async {
    expect(await Alipay.instance.isInstalled(), true);
  });

  test('pay', () async {
    final StreamSubscription<AlipayResp> sub =
        Alipay.instance.payResp().listen((AlipayResp resp) {
      expect(resp.resultStatus, 6001);
    });
    await Alipay.instance.payOrderMap(
      orderInfo: <String, String>{
        'app_id': 'mock app id',
        'biz_content': json.encode(<String, String>{
          'timeout_express': '30m',
          'product_code': 'QUICK_MSECURITY_PAY',
          'total_amount': '0.01',
          'subject': '1',
          'body': '我是测试数据',
          'out_trade_no': '123456789',
        }),
        'charset': 'utf-8',
        'method': 'alipay.trade.app.pay',
        'timestamp': '2016-07-29 16:55:53',
        'version': '1.0',
      },
      privateKey: MOCK_PRIVATE_KEY,
    );
    await sub.cancel();
  });
}
