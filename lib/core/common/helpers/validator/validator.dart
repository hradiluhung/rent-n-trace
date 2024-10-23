String? emailValidator(String? value) {
  if (value != null) {
    final isValid = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
    if (!isValid) {
      return "Email tidak valid";
    }
    return null;
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value != null) {
    if (value.length < 8) {
      return "Password minimal 8 karakter";
    }
    return null;
  }
  return null;
}

String? usernameValidator(String? value) {
  if (value != null) {
    if (value.isEmpty) {
      return 'Username tidak boleh kosong';
    } else if (value.length < 3) {
      return 'Username harus terdiri dari minimal 3 karakter';
    } else if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username hanya boleh terdiri dari huruf, angka, dan underscore';
    }
    return null;
  }
  return null;
}
