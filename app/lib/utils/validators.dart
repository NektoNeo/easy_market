class Validators {
  static String? requiredText(String? value) {
    if (value == null) return 'required';
    if (value.trim().isEmpty) return 'required';
    return null;
  }

  static String? maxLen(String value, int max) {
    if (value.length > max) return 'max';
    return null;
  }

  static bool isUuidLike(String value) {
    final v = value.trim();
    if (v.length < 8) return false;
    // relaxed check: contains hyphens or hex
    final re = RegExp(r'^[0-9a-fA-F-]+$');
    return re.hasMatch(v);
  }
}
