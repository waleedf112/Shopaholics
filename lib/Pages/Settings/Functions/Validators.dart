bool validateEmailSentax(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

String nameValidation(String value) {
  if (value.trim().isEmpty) {
    return 'الاسم فارغ';
  } else if (value.length < 3) {
    return 'الاسم اقل من 3 احرف';
  } else if (value.length > 10) {
    return 'الاسم اطول من 10 احرف';
  }
  return null;
}

String phoneValidation(String value) {
  int phoneNumber;
  try {
    phoneNumber = int.parse(value.trim());
  } catch (e) {
    return 'رقم الجوال غير صحيح';
  }
  if (value.trim().length != 10) {
    return 'رقم الجوال غير صحيح';
  } else if (value.trim()[0] != '0' || value.trim()[1] != '5') {
    return 'رقم الجوال لايبدأ بـ05';
  }
  return null;
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
