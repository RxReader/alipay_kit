import 'package:alipay_kit/src/alipay.dart';
import 'package:alipay_kit/src/alipay_kit_method_channel.dart';
import 'package:alipay_kit/src/alipay_kit_platform_interface.dart';
import 'package:alipay_kit/src/model/alipay_resp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAlipayKitPlatform with MockPlatformInterfaceMixin implements AlipayKitPlatform {
  @override
  Stream<AlipayResp> payResp() {
    throw UnimplementedError();
  }

  @override
  Stream<AlipayResp> authResp() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isInstalled() {
    return Future<bool>.value(true);
  }

  @override
  Future<void> pay({required String orderInfo, bool isShowLoading = true}) {
    throw UnimplementedError();
  }

  @override
  Future<void> auth({
    required String authInfo,
    bool isShowLoading = true,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  final AlipayKitPlatform initialPlatform = AlipayKitPlatform.instance;

  test('$MethodChannelAlipayKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAlipayKit>());
  });

  test('isInstalled', () async {
    final MockAlipayKitPlatform fakePlatform = MockAlipayKitPlatform();
    AlipayKitPlatform.instance = fakePlatform;

    expect(await Alipay.isInstalled(), true);
  });
}
