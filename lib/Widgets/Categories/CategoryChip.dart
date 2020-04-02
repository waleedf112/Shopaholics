import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Functions/AppLanguage.dart';

class CategoryChip extends StatelessWidget {
  String value;
  CategoryChip(this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Padding(
            padding: currentAppLanguage == AppLanguage.english ? EdgeInsets.all(3.0) : EdgeInsets.all(0),
            child: Text(value),
          ),
        ),
      ),
    );
  }
}
