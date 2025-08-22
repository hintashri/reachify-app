import 'package:get/get.dart';

class ValidationFunc {
  // AUTH
  static String? phoneValidation({String? phone}) {
    final String value = phone?.trim() ?? '';
    if (value.isEmpty) return 'Enter your mobile number';
    if (value.length.isLowerThan(6)) return 'Please enter valid mobile number';
    return null;
  }

  static String? emailValidation({String? email}) {
    final String value = email?.trim() ?? '';
    if (value.isEmpty) return 'Enter your email address';
    if (!value.isEmail) return 'Please enter valid email address';
    return null;
  }

  static String? categoryValidation({String? category, String title = ''}) {
    if (category == null) return 'Please add $title';
    return null;
  }

  static String? nameValidation({String? name, String title = ''}) {
    final String value = name?.trim() ?? '';
    if (value.isEmpty) return '${'Enter '} $title';
    return null;
  }
}
