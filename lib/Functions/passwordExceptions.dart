exceptionLoginRegister(value) {
  switch (value) {
    case 'ERROR_TOO_MANY_REQUESTS':
      return 'تم تخطي عدد المحاولات المسموح بها, حاول مره اخرى في وقت لاحق';
      break;
    case 'ERROR_WRONG_PASSWORD':
      return 'الايميل او كلمة السر غير صحيحه';
      break;
    case 'ERROR_USER_NOT_FOUND':
      return 'الايميل او كلمة السر غير صحيحه';
      break;
    case 'ERROR_EMAIL_ALREADY_IN_USE':
      return 'الايميل مسجل مسبقاً';
      break;
    default:
      print(value);
      return 'حدث خطأ غير معروف, حاول مرة اخرى في وقت لاحق';
      break;
  }
}
