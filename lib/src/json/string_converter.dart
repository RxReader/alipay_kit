int? intFromString(String json) {
  return json.isNotEmpty ? int.parse(json) : null;
}

String intToString(int object) {
  return object.toString();
}

bool boolFromString(String json) {
  return json == true.toString();
}

String boolToString(bool object) {
  return object.toString();
}
