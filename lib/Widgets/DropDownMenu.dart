import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../Functions/Translation.dart';

class CustomDropDownMenu extends StatefulWidget {
  final List<String> children;
  final Function function;
  String value;
  final String hint;
  final IconData icon;
  final hintColor;
  CustomDropDownMenu({
    @required this.children,
    this.function,
    this.value,
    this.hint,
    this.icon,
    this.hintColor = Colors.grey,
  });
  @override
  _CustomDropDownMenuState createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        widget.icon == null
            ? Container()
            : Icon(
                widget.icon,
                color: Colors.deepPurple[700].withOpacity(0.6),
                size: 20,
              ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton(
              elevation: 2,
              disabledHint: Text(
                textTranslation(ar: 'لاتوجد اختيارات متوفره', en: ''),
                style: TextStyle(color: Colors.grey.withOpacity(0.5)),
              ),
              value: widget.value,
              icon: Icon(
                Icons.arrow_drop_down,
                size: 18,
                color: widget.hintColor,
              ),
              isExpanded: true,
              hint: AutoSizeText(
                widget.hint,
                maxLines: 1,
                textDirection: TextDirection.rtl,
                style: TextStyle(color: widget.hintColor),
              ),
              items: <DropdownMenuItem<String>>[
                for (String child in widget.children)
                  DropdownMenuItem(
                    value: child,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: AutoSizeText(
                              child,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
              onChanged: (value) {
                widget.function(value);
                setState(() {
                  widget.value = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
