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
    if (widget.item is Product) {
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

      Widget likeButton() {
        if (widget.liked) {
          return IconButton(icon: Icon(Icons.favorite,color: Colors.red,), onPressed: () => setState(()=>widget.liked = false));
        } else {
          return IconButton(icon: Icon(Icons.favorite_border), onPressed: () => setState(()=>widget.liked = true));
        }
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          width: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
                height: 250,
                width: 200,
              ),
              
              TextWidget(widget.item.productName),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  likeButton(),
                  getPrice(),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (widget.item is ProductRequest) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              widget.imagePath,
              fit: BoxFit.cover,
              height: 250,
              width: 200,
            ),
            TextWidget(widget.item.productName),
          ],
        ),
      );
    }
  }
}
