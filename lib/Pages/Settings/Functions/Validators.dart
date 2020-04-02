import '../../../Functions/Translation.dart';

bool validateEmailSentax(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

String nameValidation(String value) {
  if (value.trim().isEmpty) {
    return textTranslation(ar: 'الاسم فارغ', en: 'Name is empty');
  } else if (value.length < 3) {
    return textTranslation(ar: 'الاسم اقل من 3 احرف', en: 'Name is less than 3 letters');
  } else if (value.length > 10) {
    return textTranslation(ar: 'الاسم اطول من 10 احرف', en: 'Name is more than 10 letters');
  }
  return null;
}

String phoneValidation(String value) {
  try {
    int.parse(value.trim());
  } catch (e) {
    return textTranslation(ar: 'رقم الجوال غير صحيح', en: 'Phone number is invalid');
  }
  if (value.trim().length != 10) {
    return textTranslation(ar: 'رقم الجوال غير صحيح', en: 'Phone number is invalid');
  } else if (value.trim()[0] != '0' || value.trim()[1] != '5') {
    return textTranslation(ar: 'رقم الجوال لايبدأ بـ05', en: 'Phone number doesn\'t start with 05');
  }
  return null;
}

String emailValidation(String value) {
  if (value.trim().isEmpty) {
    return textTranslation(ar: 'البريد الالكتروني فارغ', en: 'Email is empty');
  } else if (!validateEmailSentax(value)) {
    return textTranslation(ar: 'البريد الالكتروني غير صحيح', en: 'Email is invalid');
  }
  return null;
}

String passwordValidation(String value, {bool canBeEmpty = false}) {
  RegExp regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$');
  if (value.isEmpty && !canBeEmpty) {
    return textTranslation(ar: 'كلمة المرور فارغة', en: 'Password is empty');
  } else if (value.length > 0 && value.length < 6) {
    return textTranslation(ar: 'كلمه المرور اقل من 6 احرف', en: 'Password is less than 6 letters');
  } else if (!regExp.hasMatch(value)) {
    return textTranslation(
        ar: 'كلمه المرور يجب ان تحتوي على حروف وارقام!', en: 'Password must have letters and numbers');
  }
  return null;
}
