import 'package:flutter/material.dart';

import 'AppLanguage.dart';

String textTranslation({String ar, String en}) {
  if (currentAppLanguage == AppLanguage.arabic) return ar;
  if (currentAppLanguage == AppLanguage.english) return en;
  return null;
}

TextDirection layoutTranslation() {
  if (currentAppLanguage == AppLanguage.arabic) return TextDirection.rtl;
  if (currentAppLanguage == AppLanguage.english) return TextDirection.ltr;
  return null;
}
