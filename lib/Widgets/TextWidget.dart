import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

const appLangageRTL = true;
Widget TextWidget(
  String text, {
  double maxFontSize,
  double minFontSize,
  int maxLines,
  TextOverflow overflow,
  TextStyle style,
  TextAlign textAlign,
}) =>
    AutoSizeText(
      text,
      maxFontSize: maxFontSize ?? 18.0,
      minFontSize: minFontSize ?? 11.0,
      maxLines: maxLines,
      overflow: overflow,
      
      style: style,
      textAlign: textAlign,
      textDirection: appLangageRTL ? TextDirection.rtl : TextDirection.ltr,
    );
