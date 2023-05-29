#import "AlipayKitPlugin.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation AlipayKitPlugin {
    FlutterMethodChannel *_channel;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
        methodChannelWithName:@"v7lin.github.io/alipay_kit"
              binaryMessenger:[registrar messenger]];
    AlipayKitPlugin *instance = [[AlipayKitPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"isInstalled" isEqualToString:call.method]) {
        BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay:"]];
        result([NSNumber numberWithBool:isInstalled]);
    } else if ([@"setEnv" isEqualToString:call.method]) {
        result(FlutterMethodNotImplemented);
    } else if ([@"pay" isEqualToString:call.method]) {
        NSString *orderInfo = call.arguments[@"orderInfo"];
        // NSNumber * isShowLoading = call.arguments[@"isShowLoading"];
        NSString *scheme = ALIPAY_KIT_SCHEME;
        [[AlipaySDK defaultService] payOrder:orderInfo
                                  fromScheme:scheme
                                    callback:^(NSDictionary *resultDic) {
                                        [self->_channel invokeMethod:@"onPayResp" arguments:resultDic];
                                    }];
        result(nil);
    } else if ([@"auth" isEqualToString:call.method]) {
        NSString *authInfo = call.arguments[@"authInfo"];
        // NSNumber * isShowLoading = call.arguments[@"isShowLoading"];
        NSString *scheme = ALIPAY_KIT_SCHEME;
        [[AlipaySDK defaultService] auth_V2WithInfo:authInfo
                                         fromScheme:scheme
                                           callback:^(NSDictionary *resultDic) {
                                               [self->_channel invokeMethod:@"onAuthResp" arguments:resultDic];
                                           }];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [self handleOpenURL:url];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        __weak typeof(self) weakSelf = self;
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      __strong typeof(weakSelf) strongSelf = weakSelf;
                                                      [strongSelf->_channel invokeMethod:@"onPayResp" arguments:resultDic];
                                                  }];

        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             __strong typeof(weakSelf) strongSelf = weakSelf;
                                             [strongSelf->_channel invokeMethod:@"onAuthResp" arguments:resultDic];
                                         }];

        return YES;
    }
    return NO;
}

@end
