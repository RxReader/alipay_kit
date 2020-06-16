int intFromString(String json) {
  return (json?.isNotEmpty ?? false) ? int.parse(json) : null;
}

String intToString(int object) {
  return object?.toString();
}

bool boolFromString(String json) {
  return json != null ? json == true.toString() : null;
}

String boolToString(bool object) {
  return object?.toString();
}
