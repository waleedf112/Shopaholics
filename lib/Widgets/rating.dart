import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  double rating;
  List<Icon> stars = new List();
  Rating(this.rating);

  @override
  Widget build(BuildContext context) {
    double tmp = rating;
    getIcon() {
      if (rating >= 1) {
        rating -= 1;
        return Icons.star;
      } else if (rating > 0 && rating < 1) {
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: <Widget>[
          Row(
            children: stars,
          ),
          Text('  ($tmp)'),
        ],
      ),
    );
  }
}
