import 'package:alipay_kit/src/json/jser_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('smoke test', () {
    //
    expect(
        const NullableStringToBoolConverter().fromJson(true.toString()), true);
    expect(const NullableStringToBoolConverter().fromJson(false.toString()),
        false);
    expect(const NullableStringToBoolConverter().fromJson(null), false);

    expect(const NullableStringToBoolConverter().toJson(true), true.toString());
    expect(
        const NullableStringToBoolConverter().toJson(false), false.toString());

    //
    expect(
        const NullableStringToNullableIntConverter().fromJson(1.toString()), 1);
    expect(const NullableStringToNullableIntConverter().fromJson(null), null);

    expect(
        const NullableStringToNullableIntConverter().toJson(1), 1.toString());
    expect(const NullableStringToNullableIntConverter().toJson(null), null);
  });
}
