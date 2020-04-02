import 'AppLanguage.dart';
import 'Translation.dart';

String formatTime(int timestamp) {
  int difference = DateTime.now().millisecondsSinceEpoch - timestamp;
  String result;

  if (difference < 60000) {
    result = countSeconds(difference);
  } else if (difference < 3600000) {
    result = countMinutes(difference);
  } else if (difference < 86400000) {
    result = countHours(difference);
  } else if (difference < 604800000) {
    result = countDays(difference);
  } else if (difference / 1000 < 2419200) {
    result = countWeeks(difference);
  } else if (difference / 1000 < 31536000) {
    result = countMonths(difference);
  } else
    result = countYears(difference);
  String tmp = !result.startsWith("J") ? textTranslation(ar: 'قبل ', en: 'ago ') + result : result;
  if (currentAppLanguage == AppLanguage.english) {
    List<String> tmp2 = new List();
    tmp2.add(tmp.split(' ')[1]);
    tmp2.add(tmp.split(' ')[2]);
    tmp2.add(tmp.split(' ')[0]);
    tmp = tmp2.join(' ');
  }
  return tmp;
}

String countSeconds(int difference) {
  int count = (difference / 1000).truncate();
  return count > 1
      ? count.toString() + textTranslation(ar: ' ثواني', en: ' seconds')
      : textTranslation(ar: 'الآن', en: ' now');
}

String countMinutes(int difference) {
  int count = (difference / 60000).truncate();
  return count.toString() +
      (count > 1 ? textTranslation(ar: ' دقيقة', en: ' minute') : textTranslation(ar: ' دقائق', en: ' minutes'));
}

String countHours(int difference) {
  int count = (difference / 3600000).truncate();
  return count.toString() +
      (count > 1 ? textTranslation(ar: ' ساعات', en: ' hours') : textTranslation(ar: ' ساعه', en: ' hour'));
}

String countDays(int difference) {
  int count = (difference / 86400000).truncate();
  return count.toString() +
      (count > 1 ? textTranslation(ar: ' ايام', en: ' days') : textTranslation(ar: ' يوم', en: ' day'));
}

String countWeeks(int difference) {
  int count = (difference / 604800000).truncate();
  if (count > 3) {
    return textTranslation(ar: 'شهر', en: 'month');
  }
  return count.toString() +
      (count > 1 ? textTranslation(ar: ' اسابيع', en: ' weeks') : textTranslation(ar: ' اسبوع', en: ' week'));
}

String countMonths(int difference) {
  int count = (difference / 2628003000).round();
  count = count > 0 ? count : 1;
  if (count > 12) {
    return textTranslation(ar: 'سنه', en: 'year');
  }
  return count.toString() +
      (count > 1 ? textTranslation(ar: ' شهور', en: ' months') : textTranslation(ar: ' شهر', en: ' month'));
}

String countYears(int difference) {
  int count = (difference / 31536000000).truncate();
  return count.toString() +
      (count > 1 ? textTranslation(ar: ' سنوات', en: ' years') : textTranslation(ar: ' سنه', en: ' year'));
}
