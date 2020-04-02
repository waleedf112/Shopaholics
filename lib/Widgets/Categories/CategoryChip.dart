import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Button.dart';

class CategoryChip extends StatelessWidget {
  String value;
  CategoryChip(this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(value),
        ),
        
      ),
    );
  }
}