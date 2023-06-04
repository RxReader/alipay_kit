import 'package:alipay_kit/src/alipay_kit_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MethodChannelAlipayKit platform = MethodChannelAlipayKit();
  const MethodChannel channel = MethodChannel('v7lin.github.io/alipay_kit');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'isInstalled':
            return true;
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('isInstalled', () async {
    expect(await platform.isInstalled(), true);
  });
}
