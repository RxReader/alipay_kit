import 'package:flutter/widgets.dart';
import 'package:fake_alipay/src/alipay.dart';

class AlipayProvider extends InheritedWidget {
  AlipayProvider({
    Key key,
    @required this.alipay,
    @required Widget child,
  }) : super(key: key, child: child);

  final Alipay alipay;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    AlipayProvider oldProvider = oldWidget as AlipayProvider;
    return alipay != oldProvider.alipay;
  }

  static AlipayProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AlipayProvider)
        as AlipayProvider;
  }
}
