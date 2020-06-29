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

static NSString *const METHOD_ISINSTALLED = @"isInstalled";
static NSString *const METHOD_PAY = @"pay";
static NSString *const METHOD_AUTH = @"auth";

static NSString *const METHOD_ONPAYRESP = @"onPayResp";
static NSString *const METHOD_ONAUTHRESP = @"onAuthResp";

static NSString *const ARGUMENT_KEY_ORDERINFO = @"orderInfo";
static NSString *const ARGUMENT_KEY_AUTHINFO = @"authInfo";
static NSString *const ARGUMENT_KEY_ISSHOWLOADING = @"isShowLoading";

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([METHOD_ISINSTALLED isEqualToString:call.method]) {
        BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay:"]];
        result([NSNumber numberWithBool:isInstalled]);
    } else if ([METHOD_PAY isEqualToString:call.method]) {
        NSString *orderInfo = call.arguments[ARGUMENT_KEY_ORDERINFO];
        //        NSNumber * isShowLoading = call.arguments[ARGUMENT_KEY_ISSHOWLOADING];
        NSString *scheme = [self fetchUrlScheme];
        [[AlipaySDK defaultService] payOrder:orderInfo
                                  fromScheme:scheme
                                    callback:^(NSDictionary *resultDic) {
                                        [self->_channel invokeMethod:METHOD_ONPAYRESP arguments:resultDic];
                                    }];
        result(nil);
    } else if ([METHOD_AUTH isEqualToString:call.method]) {
        NSString *authInfo = call.arguments[ARGUMENT_KEY_AUTHINFO];
        //        NSNumber * isShowLoading = call.arguments[ARGUMENT_KEY_ISSHOWLOADING];
        NSString *scheme = [self fetchUrlScheme];
        [[AlipaySDK defaultService] auth_V2WithInfo:authInfo
                                         fromScheme:scheme
                                           callback:^(NSDictionary *resultDic) {
                                               [self->_channel invokeMethod:METHOD_ONAUTHRESP arguments:resultDic];
                                           }];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

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
                                                      [strongSelf->_channel invokeMethod:METHOD_ONPAYRESP arguments:resultDic];
                                                  }];

        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             __strong typeof(weakSelf) strongSelf = weakSelf;
                                             [strongSelf->_channel invokeMethod:METHOD_ONAUTHRESP arguments:resultDic];
                                         }];

        return YES;
    }
    return NO;
}

@end
