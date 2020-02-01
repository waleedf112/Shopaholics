bool validateEmailSentax(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

String emailValidation(String value) {
  if (value.trim().isEmpty) {
    return 'البريد الالكتروني فارغ';
  } else if (!validateEmailSentax(value)) {
    return 'البريد الالكتروني غير صحيح';
  }
  return null;
}

String passwordValidation(String value) {
  if (value.isEmpty) {
    return 'كلمة المرور فارغة';
  } else if (value.length < 6) {
    return 'كلمه المرور اقل من 6 احرف';
  }
  return null;
}
