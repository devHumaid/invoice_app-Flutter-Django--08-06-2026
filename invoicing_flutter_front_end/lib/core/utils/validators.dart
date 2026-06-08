class Validators {
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final pattern = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!pattern.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    final pattern = RegExp(r'^\+?[0-9]{10,15}$');
    if (!pattern.hasMatch(value)) return 'Enter a valid 10-15 digit phone number';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? hsnSac(String? value, String label) {
    if (value == null || value.isEmpty) return '$label code is required';
    final pattern = RegExp(r'^\d{6}$');
    if (!pattern.hasMatch(value)) return '$label must be exactly 6 digits';
    return null;
  }

  static String? price(String? value) {
    if (value == null || value.isEmpty) return 'Price is required';
    final parsed = double.tryParse(value);
    if (parsed == null || parsed <= 0) return 'Enter a valid price';
    return null;
  }
}
