import 'package:shopaholics/Classes/Product.dart';
import 'package:flutter/material.dart';

import 'TextWidget.dart';

class ProductWidget extends StatefulWidget {
  String imagePath;
  var item;
  bool liked = false;
  ProductWidget(@required this.item, @required this.imagePath);

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    
      Widget likeButton() {
        if (widget.liked) {
          return IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () => setState(() => widget.liked = false));
        } else {
          return IconButton(icon: Icon(Icons.favorite_border), onPressed: () => setState(() => widget.liked = true));
        }
      }

      infoText() {
        return Padding(
          padding: const EdgeInsets.only(top: 3, right: 7),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextWidget('قبل 17 ساعة', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  TextWidget(widget.item.productName,style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        );
      }
            Widget getPrice() {
        if (widget.item.hasDiscount())
          return Column(
            children: <Widget>[
              TextWidget(
                '${widget.item.getPrice()} ريال',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5),
              TextWidget(
                '${widget.item.getOldPrice()} ريال',
                style: TextStyle(
                    color: Colors.grey.withOpacity(0.7),
                    decoration: TextDecoration.lineThrough,
                    fontStyle: FontStyle.italic,
                    fontSize: 11),
              ),
            ],
          );
        return TextWidget('${widget.item.getPrice()} ريال');
      }

    if (widget.item is Product) {


      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          width: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  width: 200,
                ),
              ),
              Container(height: 50,child: infoText()),
              Padding(
                padding: const EdgeInsets.only(right: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getPrice(),
                    likeButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (widget.item is ProductRequest) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          width: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  width: 200,
                ),
              ),
              Container(height: 50,child: infoText()),
              Padding(
                padding: const EdgeInsets.only(right: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextWidget('500 ريال'),

                    likeButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
