import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

import '../../Functions/Translation.dart';
import '../../Widgets/TextWidget.dart';

NoProductsInCart() => Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Mdi.cartRemove,
            color: Colors.grey.withOpacity(0.6),
            size: 100,
          ),
          TextWidget(textTranslation(ar: 'لاتوجد أي منتجات في العربة', en: 'You Have No Prodects in Your Cart'),
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ))
        ],
      ),
    );
