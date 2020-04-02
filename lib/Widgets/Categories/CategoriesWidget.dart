import 'package:flutter/material.dart';
import 'package:shopaholics/Functions/AppLanguage.dart';

import '../../Functions/Translation.dart';
import 'CategoriesText.dart';

ValueNotifier<int> mainCategoryNotifier = new ValueNotifier<int>(null);
ValueNotifier<List<int>> subCategoriesNotifier = new ValueNotifier<List<int>>(null);

class CategoriesWidget extends StatefulWidget {
  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.7), width: 0.5)),
      child: Directionality(
textDirection: layoutTranslation(),        child: ValueListenableBuilder(
          valueListenable: mainCategoryNotifier,
          builder: (BuildContext context, int value, Widget child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: categories_arabic.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return RadioListTile(
                          value: index,
                          groupValue: mainCategoryNotifier.value,
                          title: Text(currentAppLanguage== AppLanguage.arabic?categories_arabic.keys.elementAt(index):categories_english.keys.elementAt(index)),
                          onChanged: (_) {
                            mainCategoryNotifier.value = index;
                            subCategoriesNotifier.value = new List();
                          },
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: subCategoriesNotifier,
                    builder: (BuildContext context, dynamic value, Widget child) {
                      if (mainCategoryNotifier.value == null) {
                        return Center(
                          child: Text(
                            textTranslation(ar: 'اختر قسم رئيسي', en: 'Choose a Category'),
                            style: TextStyle(color: Colors.grey, fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        );
                      } else {
                        List<String> values =
                            currentAppLanguage== AppLanguage.arabic?categories_arabic[categories_arabic.keys.elementAt(mainCategoryNotifier.value)]:categories_english[categories_english.keys.elementAt(mainCategoryNotifier.value)];
                        return Scrollbar(
                          child: ListView.builder(
                            itemCount: values.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return CheckboxListTile(
                                value: subCategoriesNotifier.value.contains(index),
                                title: Text(values[index]),
                                onChanged: (isAdd) {
                                  if (isAdd) {
                                    subCategoriesNotifier.value.add(index);
                                  } else {
                                    subCategoriesNotifier.value.remove(index);
                                  }
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
