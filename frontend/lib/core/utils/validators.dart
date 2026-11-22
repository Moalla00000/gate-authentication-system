/// A utility class containing static methods for common form validations.
class Validators {
  /// Validates an email address using a standard regex pattern.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  /// Validates a password input ensuring it is not entirely empty.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return null;
  }

  /// Validates a new password input ensuring it reaches minimum length criteria.
  static String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Minimum 6 characters required';
    return null;
  }

  /// Validates a name input ensuring it's not empty and meets a minimum length.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Minimum 2 characters required';
    return null;
  }
}
