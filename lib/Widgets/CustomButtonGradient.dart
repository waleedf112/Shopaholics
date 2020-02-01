import 'package:flutter/material.dart';

customGradient(Color color, [x, y, opacity]) {
  return LinearGradient(
      colors: [color.withOpacity(opacity ?? 0.8), Colors.white],
      begin: Alignment.centerRight,
      end: new Alignment(x ?? -1.0, y ?? -6.0));
}
