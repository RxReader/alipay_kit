import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fake_alipay/fake_alipay.dart';

void main() {
  runZoned(() {
    runApp(MyApp());
  }, onError: (Object error, StackTrace stack) {
    print(error);
    print(stack);
  });

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Alipay alipay = Alipay();
    alipay.registerApp();
    return AlipayProvider(
      alipay: alipay,
      child: MaterialApp(
        home: Home(alipay: alipay),
      ),
    );
  }
}

class Home extends StatefulWidget {

  Home({
    Key key,
    @required this.alipay,
  }) : super(key: key);

  final Alipay alipay;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

/// pkcs1 -> '-----BEGIN RSA PRIVATE KEY-----\n${支付宝RSA签名工具生产的私钥}\n-----END RSA PRIVATE KEY-----'
/// pkcs8 -> '-----BEGIN PRIVATE KEY-----\n${支付宝RSA签名工具生产的私钥}\n-----END PRIVATE KEY-----'
class _HomeState extends State<Home> {
  static const bool _alipayUseRsa2  = true;
  static const String _alipayAppId = 'your alipay appId';
  static const String _alipayPid = 'your alipay pid';
  static const String _alipayTargetId = 'your alipay targetId';
  static const String _alipayPrivateKey = 'your alipay rsa private key(pkcs1/pkcs8)';

  StreamSubscription<AlipayResp> _pay;
  StreamSubscription<AlipayResp> _auth;

  @override
  void initState() {
    super.initState();
    _pay = widget.alipay.payResp().listen(_listenPay);
    _auth = widget.alipay.authResp().listen(_listenAuth);
  }

  void _listenPay(AlipayResp resp) {
    String content = 'pay: ${resp.resultStatus} - ${resp.result}';
    _showTips('支付', content);
  }

  void _listenAuth(AlipayResp resp) {
    String content = 'pay: ${resp.resultStatus} - ${resp.result}';
    _showTips('授权登录', content);
  }

  @override
  void dispose() {
    if (_pay != null) {
      _pay.cancel();
    }
    if (_auth != null) {
      _auth.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Alipay Demo'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('环境检查'),
            onTap: () async {
              String content =
                  'alipay: ${await widget.alipay.isAlipayInstalled()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: const Text('支付'),
            onTap: () {
              Map<String, String> bizContent = {
                'timeout_express': '30m',
                'product_code': 'QUICK_MSECURITY_PAY',
                'total_amount': '0.01',
                'subject': '1',
                'body': '我是测试数据',
                'out_trade_no': '123456789',
              };
              Map<String, String> orderInfo = {
                'app_id': _alipayAppId,
                'biz_content': json.encode(bizContent),
                'charset': 'utf-8',
                'method': 'alipay.trade.app.pay',
                'timestamp': '2016-07-29 16:55:53',
                'version': '1.0',
              };
              widget.alipay.payOrderMap(
                orderInfo: orderInfo,
                signType: _alipayUseRsa2 ? Alipay.SIGNTYPE_RSA2 : Alipay.SIGNTYPE_RSA,
                privateKey: _alipayPrivateKey,
              );
            },
          ),
          ListTile(
            title: const Text('授权'),
            onTap: () {
              String appId = _alipayAppId;
              String pid = _alipayPid;
              String targetId = _alipayTargetId;
              String privateKey = _alipayPrivateKey;
              widget.alipay.auth(
                appId: appId,
                pid: pid,
                targetId: targetId,
                privateKey: privateKey,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showTips(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }
}
