import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

import '../../Functions/Translation.dart';
import '../../Widgets/TextWidget.dart';

NoRequestsPage() => Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Mdi.cartOff,
            color: Colors.grey.withOpacity(0.6),
            size: 100,
          ),
          TextWidget(textTranslation(ar: 'لاتوجد لديك أي طلبات', en: ''),
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ))
        ],
      ),
    );
