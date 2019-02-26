import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:fake_alipay/fake_alipay.dart';
import 'package:flutter/services.dart';

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
    FakeAlipay alipay = FakeAlipay();
    alipay.registerApp();
    return FakeAlipayProvider(
      alipay: alipay,
      child: MaterialApp(
        home: Home(alipay: alipay),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final FakeAlipay alipay;

  Home({
    Key key,
    @required this.alipay,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  static const bool ALIPAY_USE_RSA2  = true;
  static const String ALIPAY_APPID = 'your alipay appId';
  static const String ALIPAY_PID = 'your alipay pid';
  static const String ALIPAY_TARGETID = 'your alipay targetId';
  static const String ALIPAY_PRIVATEKEY = 'your alipay rsa private key(pkcs8)';

  StreamSubscription<FakeAlipayResp> _pay;
  StreamSubscription<FakeAlipayResp> _auth;

  @override
  void initState() {
    super.initState();
    _pay = widget.alipay.payResp().listen(_listenPay);
    _auth = widget.alipay.authResp().listen(_listenAuth);
  }

  void _listenPay(FakeAlipayResp resp) {
    String content = 'pay: ${resp.resultStatus} - ${resp.result}';
    _showTips('支付', content);
  }

  void _listenAuth(FakeAlipayResp resp) {
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
                'app_id': ALIPAY_APPID,
                'biz_content': json.encode(bizContent),
                'charset': 'utf-8',
                'method': 'alipay.trade.app.pay',
                'timestamp': '2016-07-29 16:55:53',
                'version': '1.0',
              };
              widget.alipay.payOrderMap(
                orderInfo: orderInfo,
                signType: ALIPAY_USE_RSA2 ? FakeAlipay.SIGNTYPE_RSA2 : FakeAlipay.SIGNTYPE_RSA,
                privateKey: ALIPAY_PRIVATEKEY,
              );
            },
          ),
          ListTile(
            title: const Text('授权'),
            onTap: () {
              String appId = ALIPAY_APPID;
              String pid = ALIPAY_PID;
              String targetId = ALIPAY_TARGETID;
              String privateKey = ALIPAY_PRIVATEKEY;
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
