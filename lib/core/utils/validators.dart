class Validators {
  Validators._();

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Enter a valid number';
    }
    if (age < 18 || age > 60) {
      return 'Age must be between 18 and 60';
    }
    return null;
  }

  static String? validateOptional(String? value) {
    return null; // always valid, field is optional
  }
}