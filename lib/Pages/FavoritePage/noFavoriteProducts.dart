import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

import '../../Functions/Translation.dart';
import '../../Widgets/TextWidget.dart';

NoFavoriteProducts() => Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Mdi.heartBroken,
            color: Colors.grey.withOpacity(0.6),
            size: 100,
          ),
          TextWidget(textTranslation(ar: 'لاتوجد أي منتجات في المفضلة', en: 'You don\'t have any favorites'),
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ))
        ],
      ),
    );
