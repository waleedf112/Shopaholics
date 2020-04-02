import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'TextWidget.dart';

class Rating extends StatelessWidget {
  double rating;
  List<Icon> stars = new List();
  Rating(this.rating);

  @override
  Widget build(BuildContext context) {
    double tmp = rating;
    getIcon() {
      if (rating != null && rating >= 1) {
        rating -= 1;
        return Icons.star;
      } else if (rating != null && rating > 0 && rating < 1) {
        rating = 0;

        return Icons.star_half;
      } else {
        return Icons.star_border;
      }
    }

    for (int i = 1; i <= 5; i++) {
      stars.add(Icon(
        getIcon(),
        color: Colors.green[800],
      ));
    }
    if (rating == null)
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: <Widget>[
            Row(children: stars),
            Text('  (N/A)'),
          ],
        ),
      );
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: <Widget>[
          Row(
            children: stars,
          ),
          Text('  (${tmp.toStringAsFixed(2)})'),
        ],
      ),
    );
  }
}

class GiveRating extends StatefulWidget {
  String uid;
  String displayName;
  int rating = 0;
  Color color = Colors.green[700];
  String orderId;
  GiveRating({this.uid, this.displayName, this.orderId});

  @override
  _GiveRatingState createState() => _GiveRatingState();
}

class _GiveRatingState extends State<GiveRating> {
  Widget _buildStarWidget(int index) {
    Widget _getIcon() => widget.rating > index - 1 ? Icon(Icons.star) : Icon(Icons.star_border);
    void _setRating() {
      if (widget.rating == 0) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            textTranslation(ar: 'تم تقييم ${widget.displayName} بنجاح!', en: ''),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: Colors.black.withOpacity(0.7),
          elevation: 0,
          duration: Duration(milliseconds: 1500),
        ));
        Firestore.instance.collection('Users').document(widget.uid).get().then((onValue) {
          int ratingCount = 0;
          if (onValue['ratingCount'] != null) ratingCount = onValue['ratingCount'];
          double rating = ((onValue['rating'] * ratingCount) + index) / (ratingCount + 1);
          ratingCount++;

          Firestore.instance.collection('Users').document(widget.uid).updateData({
            'rating': rating,
            'ratingCount': ratingCount,
          });
          Firestore.instance.collection('Orders').document(widget.orderId).updateData({'hasBeenRated': true});
        });
        setState(() => widget.rating = index);
      }
    }

    return IconButton(
      icon: _getIcon(),
      color: widget.color,
      onPressed: () => _setRating(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(color: Colors.grey),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            children: <Widget>[
              Expanded(child: TextWidget(widget.displayName + ':')),
              Row(children: List.generate(5, (i) => _buildStarWidget(i + 1))),
            ],
          ),
        ),
      ],
    );
  }
}
