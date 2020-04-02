import 'package:flutter/material.dart';

import '../Functions/Translation.dart';
import 'TextWidget.dart';

NoSearchResult() => Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.search,
            color: Colors.grey.withOpacity(0.6),
            size: 100,
          ),
          TextWidget(textTranslation(ar: 'لاتوجد أي منتجات تطابق بحثك', en: 'Your Search hasen\'t matched any results'),
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ))
        ],
      ),
    );
