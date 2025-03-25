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

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 8) return "Password must be at least 8 characters";
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) return "Must contain an uppercase letter";
    if (!RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(value)) return "Must contain a special character";
    return null;
  }


  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return "Please confirm your password";
    if (value != password) return "Passwords do not match";
    return null;
  }

  static String? validateNormalField(String? value, String title) {
    if (value == null || value.isEmpty) return "$title required";
    return null;
  }

  // Username Validation
  static String? validateUserName(String? value, bool checkUserName) {
    if (value == null || value.isEmpty) {
      return 'Username required';
    } else if (value.contains(' ')) {
      return 'Username cannot contain spaces';
    } else if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Only letters, numbers, and underscores allowed';
    } else if (checkUserName == false) {
      return 'Username is already taken';
    } else {
      return null;
    }
  }




  static bool hasMinLength(String password) {
    return password.length >= 8;
  }

  static bool hasUpperCase(String password) {
    return RegExp(r'(?=.*[A-Z])').hasMatch(password);
  }

  static bool hasSpecialChar(String password) {
    return RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(password);
  }

  static int strength(String password) {
    int count = 0;
    if (password.length >= 8) count++;
    if (RegExp(r'(?=.*[A-Z])').hasMatch(password)) count++;
    if (RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(password)) count++;
    return count;
  }
}
