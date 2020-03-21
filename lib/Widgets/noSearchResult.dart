import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';

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
          TextWidget('لاتوجد أي منتجات تطابق بحثك',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ))
        ],
      ),
    );
