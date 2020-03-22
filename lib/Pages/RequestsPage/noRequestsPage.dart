import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';

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
          TextWidget('لاتوجد لديك أي طلبات',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ))
        ],
      ),
    );
