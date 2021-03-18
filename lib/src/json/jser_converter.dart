import 'package:json_annotation/json_annotation.dart';

class NullableStringToBoolConverter implements JsonConverter<bool, String?> {
  const NullableStringToBoolConverter();

  @override
  bool fromJson(String? json) {
    return json == true.toString();
  }

  @override
  String? toJson(bool object) {
    return object.toString();
  }
}

class NullableStringToNullableIntConverter
    implements JsonConverter<int?, String?> {
  const NullableStringToNullableIntConverter();

  @override
  int? fromJson(String? json) {
    if (json is String) {
      return int.tryParse(json);
    }
    return null;
  }

  @override
  String? toJson(int? object) {
    return object?.toString();
  }
}
