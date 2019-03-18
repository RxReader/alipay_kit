import 'package:flutter_test/flutter_test.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

void main() {
  test('smoke test - snake case', () {
    print('${toSnakeCase('oneField')}');
    print('${toSnakeCase('oneField_street')}');
    print('${toSnakeCase('one_field')}');
  });

  test('smoke test - kebab case', () {
    print('${toKebabCase('oneField')}');
    print('${toKebabCase('oneField_street')}');
    print('${toKebabCase('one_field')}');
  });

  test('smoke test - camel case', () {
    print('${toCamelCase('oneField')}');
    print('${toCamelCase('oneField_street')}');
    print('${toCamelCase('one_field')}');
  });
}