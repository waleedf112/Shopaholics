import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AlertMessage extends StatelessWidget {
  final String message;
  final IconData messageIcon;
  Color color;
  final int maxLines;
  final TextAlign textAlign;
  final double fontSize;
  final bool centerIcon;
  AlertMessage({
    @required this.message,
    this.color,
    this.messageIcon = Icons.info_outline,
    this.maxLines = 5,
    this.textAlign,
    this.fontSize = 13,
    this.centerIcon = false,
  });
  @override
  Widget build(BuildContext context) {
    if (this.color == null) this.color = Colors.grey[800];
    return _HighlightText(
      opacity: 0.08,
      padding: 12.0,
      color: color,
      icon: messageIcon,
      centerIcon: centerIcon,
      child: AutoSizeText(
        message,
        maxLines: maxLines,
        maxFontSize: fontSize,
        textDirection: TextDirection.rtl,
        textAlign: textAlign,
        style: TextStyle(fontSize: fontSize, color: color.withOpacity(0.9)),
      ),
    );
  }
}

class _HighlightText extends StatelessWidget {
  final Widget child;
  final Color color;
  final IconData icon;
  final double opacity;
  final double padding;
  final bool centerIcon;
  _HighlightText({
    @required this.child,
    this.color = Colors.grey,
    this.icon,
    this.opacity = 0.3,
    this.padding = 8.0,
    this.centerIcon,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color.withOpacity(opacity), borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          crossAxisAlignment: centerIcon ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: child),
            icon == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: 7, top: 0),
                    child: Icon(
                      icon,
                      color: color.withOpacity(0.5),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
