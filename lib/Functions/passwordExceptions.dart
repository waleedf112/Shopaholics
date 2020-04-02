import 'Translation.dart';

exceptionLoginRegister(value) {
  switch (value) {
    case 'ERROR_TOO_MANY_REQUESTS':
      return textTranslation(
          ar: 'تم تخطي عدد المحاولات المسموح بها, حاول مره اخرى في وقت لاحق',
          en: 'Maximum number of tries reached, please try again later.');
      break;
    case 'ERROR_WRONG_PASSWORD':
      return textTranslation(ar: 'الايميل او كلمة السر غير صحيحه', en: 'Email of password is invalid');
      break;
    case 'ERROR_USER_NOT_FOUND':
      return textTranslation(ar: 'الايميل او كلمة السر غير صحيحه', en: 'Email of password is invalid');
      break;
    case 'ERROR_EMAIL_ALREADY_IN_USE':
      return textTranslation(ar: 'الايميل مسجل مسبقاً', en: 'Email is already registerd');
      break;
    default:
      print(value);
      return textTranslation(
          ar: 'حدث خطأ غير معروف, حاول مرة اخرى في وقت لاحق', en: 'Unkowen error happened, try again later');
      break;
  }
}
