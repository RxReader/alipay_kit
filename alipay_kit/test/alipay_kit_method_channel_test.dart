import 'package:alipay_kit/src/alipay_kit_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final MethodChannelAlipayKit platform = MethodChannelAlipayKit();
  const MethodChannel channel = MethodChannel('v7lin.github.io/alipay_kit');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'isInstalled':
          return true;
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('isInstalled', () async {
    expect(await platform.isInstalled(), true);
  });
}
