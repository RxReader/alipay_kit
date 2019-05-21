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

const FieldProcessor<bool, String> boolToStringProcessor =
    BoolToStringProcessor();
