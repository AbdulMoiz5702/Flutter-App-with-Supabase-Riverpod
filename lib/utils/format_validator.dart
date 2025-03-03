class FormValidators {
  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required";
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  // Phone Validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return "Phone number is required";
    if (!RegExp(r'^\d{10,15}$').hasMatch(value)) return "Enter a valid phone number";
    return null;
  }

  // Password Validation (8+ chars, 1 uppercase, 1 special char)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 8) return "Password must be at least 8 characters";
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) return "Must contain an uppercase letter";
    if (!RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(value)) return "Must contain a special character";
    return null;
  }

  // Confirm Password Validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return "Please confirm your password";
    if (value != password) return "Passwords do not match";
    return null;
  }
}
