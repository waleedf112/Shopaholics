import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

enum CardBorders { highest, higher, high, normal, low, none }
enum CardShadow { highest, high, normal, low, none }

Widget SimpleButton(String text, {Function function, bool boldText = false}) => Row(
      children: <Widget>[
        Expanded(
          child: CustomButton(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: boldText ? FontWeight.bold : null,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            color: Colors.black.withOpacity(0.8),
            function: function,
          ),
        ),
      ],
    );

class CustomButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double opacity;
  final CardBorders cardBorders;
  final CardBorders cardBordersTopLeft;
  final CardBorders cardBordersTopRight;
  final CardBorders cardBordersBottomLeft;
  final CardBorders cardBordersBottomRight;
  final CardShadow cardShadow;
  final Function function;
  final bool showShadow;
  final Color shadowColor;
  final Color splashColor;
  final double width;
  CustomButton({
    @required this.child,
    this.color = Colors.white,
    this.opacity = 1.0,
    this.cardBorders = CardBorders.none,
    this.cardShadow = CardShadow.none,
    this.function,
    this.showShadow = true,
    this.cardBordersBottomLeft,
    this.cardBordersBottomRight,
    this.cardBordersTopLeft,
    this.cardBordersTopRight,
    this.shadowColor,
    this.splashColor,
    this.width,
  });
  @override
  Widget build(BuildContext context) {
    double getCardBorders(_borders) {
      switch (_borders) {
        case CardBorders.none:
          return 0.0;
          break;
        case CardBorders.low:
          return 10.0;
          break;
        case CardBorders.normal:
          return 15.0;
          break;
        case CardBorders.high:
          return 25.0;
          break;
        case CardBorders.higher:
          return 50.0;
          break;
        case CardBorders.highest:
          return 60.0;
          break;
        default:
          return 0.0;

          break;
      }
    }

    BoxShadow getCardShadows() {
      Color _color = shadowColor != null
          ? shadowColor
          : color == Colors.white ? Colors.red.withOpacity(0.1) : color.withOpacity(0.4);
      switch (cardShadow) {
        case CardShadow.none:
          return BoxShadow(color: _color, spreadRadius: 0, offset: Offset(0.0, 0.0), blurRadius: 0.0);
          break;
        case CardShadow.low:
          return BoxShadow(color: _color, spreadRadius: 0, offset: Offset(2.0, 4.0), blurRadius: 5.0);
          break;
        case CardShadow.normal:
          return BoxShadow(color: _color, spreadRadius: 2, offset: Offset(2.0, 4.0), blurRadius: 5.0);
          break;
        case CardShadow.high:
          return BoxShadow(color: _color, spreadRadius: 3, offset: Offset(2.0, 4.0), blurRadius: 8.0);
          break;
        case CardShadow.highest:
          return BoxShadow(color: _color, spreadRadius: 5, offset: Offset(3.0, 8.0), blurRadius: 12.0);
          break;
        default:
          return BoxShadow(color: _color, spreadRadius: 5, offset: Offset(3.0, 8.0), blurRadius: 12.0);

          break;
      }
    }

    getWidget() {
      return Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(getCardBorders(cardBordersTopLeft ?? cardBorders)),
            topRight: Radius.circular(getCardBorders(cardBordersTopRight ?? cardBorders)),
            bottomLeft: Radius.circular(getCardBorders(cardBordersBottomLeft ?? cardBorders)),
            bottomRight: Radius.circular(getCardBorders(cardBordersBottomRight ?? cardBorders)),
          ),
        ),
        child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(getCardBorders(cardBordersTopLeft ?? cardBorders)),
                topRight: Radius.circular(getCardBorders(cardBordersTopRight ?? cardBorders)),
                bottomLeft: Radius.circular(getCardBorders(cardBordersBottomLeft ?? cardBorders)),
                bottomRight: Radius.circular(getCardBorders(cardBordersBottomRight ?? cardBorders)),
              ),
              gradient: LinearGradient(
                  begin: Alignment.bottomRight, end: new Alignment(-8.0, -2.0), colors: [color, Colors.white]),
              boxShadow: showShadow
                  ? <BoxShadow>[
                      getCardShadows(),
                    ]
                  : null,
            ),
            child: child),
      );
    }

    if (function == null) return getWidget();
    return Stack(
      children: <Widget>[
        getWidget(),
        new Positioned.fill(
          child: new Material(
            color: Colors.transparent,
            child: new InkWell(
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(getCardBorders(cardBordersTopLeft ?? cardBorders)),
                topRight: Radius.circular(getCardBorders(cardBordersTopRight ?? cardBorders)),
                bottomLeft: Radius.circular(getCardBorders(cardBordersBottomLeft ?? cardBorders)),
                bottomRight: Radius.circular(getCardBorders(cardBordersBottomRight ?? cardBorders)),
              ),
              splashColor: splashColor != null
                  ? splashColor.withOpacity(0.4)
                  : color == Colors.white ? Colors.grey.withOpacity(0.2) : color.withOpacity(0.4),
              onTap: function,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomButtonPrimary extends StatelessWidget {
  final String text;
  final Color color;
  final Function function;
  final IconData iconRight;
  final IconData iconLeft;
  final CardBorders cardBorders;
  final double fontSize;
  final bool showShadow;
  final CardShadow cardShadow;
  final Widget rightImage;
  final Widget leftImage;
  final Color textColor;
  final TextAlign textAlign;
  final GlobalKey<State<StatefulWidget>> key;
  CustomButtonPrimary(
      {@required this.text,
      this.color = Colors.red,
      @required this.function,
      this.cardBorders,
      this.fontSize = 20,
      this.showShadow = true,
      this.cardShadow = CardShadow.none,
      this.iconRight,
      this.iconLeft,
      this.rightImage,
      this.leftImage,
      this.textColor,
      this.textAlign = TextAlign.center,
      this.key})
      : assert(iconLeft == null || iconRight == null);
  @override
  Widget build(BuildContext context) {
    _iconBuilder(IconData icon) {
      return Padding(
        padding: EdgeInsets.only(
          right: iconRight != null ? 10 : 0,
          left: iconLeft != null ? 10 : 0,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      );
    }

    return CustomButton(
      cardShadow: cardShadow,
      showShadow: showShadow,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          iconLeft != null
              ? _iconBuilder(iconLeft)
              : rightImage != null
                  ? Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: rightImage,
                    )
                  : Container(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: iconLeft != null ? 0 : 20,
                right: iconRight != null ? 0 : 20,
              ),
              child: Padding(
                padding: EdgeInsets.all(fontSize / 2),
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: AutoSizeText(
                    text,
                    maxLines: 1,
                    style: TextStyle(
                      color: textColor != null ? textColor : Colors.white,
                      fontSize: fontSize,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: textAlign,
                  ),
                ),
              ),
            ),
          ),
          iconRight != null
              ? _iconBuilder(iconRight)
              : leftImage != null
                  ? Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: leftImage,
                    )
                  : Container()
        ],
      ),
      color: color,
      cardBorders: cardBorders,
      function: function,
    );
  }
}

Widget OutlinedButton({String text, Function function, Widget child}) => RaisedButton(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightElevation: 0,
      hoverElevation: 0,
      child: Container(
        decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          child: child ?? Text(text),
        ),
      ),
      color: Colors.white,
      elevation: 0,
      onPressed: function ?? () {},
    );
