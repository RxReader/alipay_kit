#import "AlipayKitPlugin.h"
#ifndef NONE_PAY
#import <AlipaySDK/AlipaySDK.h>
#endif

@implementation AlipayKitPlugin {
    FlutterMethodChannel *_channel;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
#ifndef NONE_PAY
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"v7lin.github.io/alipay_kit"
                                     binaryMessenger:[registrar messenger]];
    AlipayKitPlugin *instance = [[AlipayKitPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
#endif
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
#ifndef NONE_PAY
    if ([@"isInstalled" isEqualToString:call.method]) {
        BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay:"]];
        result([NSNumber numberWithBool:isInstalled]);
    } else if ([@"pay" isEqualToString:call.method]) {
        NSString *orderInfo = call.arguments[@"orderInfo"];
        // NSNumber * isShowLoading = call.arguments[@"isShowLoading"];
        NSString *scheme = [self fetchUrlScheme];
        [[AlipaySDK defaultService] payOrder:orderInfo
                                  fromScheme:scheme
                                    callback:^(NSDictionary *resultDic) {
                                        [self->_channel invokeMethod:@"onPayResp" arguments:resultDic];
                                    }];
        result(nil);
    } else if ([@"auth" isEqualToString:call.method]) {
        NSString *authInfo = call.arguments[@"authInfo"];
        // NSNumber * isShowLoading = call.arguments[@"isShowLoading"];
        NSString *scheme = [self fetchUrlScheme];
        [[AlipaySDK defaultService] auth_V2WithInfo:authInfo
                                         fromScheme:scheme
                                           callback:^(NSDictionary *resultDic) {
                                               [self->_channel invokeMethod:@"onAuthResp" arguments:resultDic];
                                           }];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
#else
    result(FlutterMethodNotImplemented);
#endif
}

#ifndef NONE_PAY
- (NSString *)fetchUrlScheme {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSArray *types = [infoDic objectForKey:@"CFBundleURLTypes"];
    for (NSDictionary *type in types) {
        if ([@"alipay" isEqualToString:[type objectForKey:@"CFBundleURLName"]]) {
            return [type objectForKey:@"CFBundleURLSchemes"][0];
        }
    }
    return nil;
}
#endif

#pragma mark - AppDelegate

#ifndef NONE_PAY
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
#endif

@end
