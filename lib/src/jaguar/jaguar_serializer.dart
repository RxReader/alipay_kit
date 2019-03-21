import 'package:jaguar_serializer/jaguar_serializer.dart';

class BoolToStringProcessor implements FieldProcessor<bool, String> {
  const BoolToStringProcessor();

  @override
  bool deserialize(String value) {
    return value != null ? value == true.toString() : null;
  }

  @override
  String serialize(bool value) {
    return value?.toString();
  }
}

class StringToBoolProcessor implements FieldProcessor<String, bool> {
  const StringToBoolProcessor();

  @override
  String deserialize(bool value) {
    return value?.toString();
  }

  @override
  bool serialize(String value) {
    return value != null ? value == true.toString() : null;
  }
}

const FieldProcessor<bool, String> boolToStringProcessor =
    BoolToStringProcessor();
const FieldProcessor<String, bool> stringToBoolProcessor =
    StringToBoolProcessor();
