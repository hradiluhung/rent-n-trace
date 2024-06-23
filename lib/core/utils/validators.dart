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
