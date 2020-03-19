import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_fade/image_fade.dart';
import 'package:mdi/mdi.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';

class MyOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'طلباتي',
      child: FutureBuilder(
        future: Firestore.instance
            .collection('Orders')
            .where('uid', isEqualTo: currentUser.uid)
            .getDocuments(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.isEmpty)
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[NoOrders()],
              );
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return _Order(snapshot.data.documents[index].data);
              },
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitHourGlass(color: Colors.grey.withOpacity(0.4)),
            ],
          );
        },
      ),
    );
  }
}

class _Order extends StatelessWidget {
  Map data;
  _Order(this.data);

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(data['dateTime']);
    Widget status;
    if (data['statusIconIndex'] == 0) {
      status = Padding(
        padding: const EdgeInsets.only(left: 5, right: 3),
        child: Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 15,
        ),
      );
    } else if (data['statusIconIndex'] == 1) {
      status = Padding(
        padding: const EdgeInsets.only(left: 5, right: 3),
        child: Icon(
          Icons.pause_circle_filled,
          color: Colors.orange,
          size: 15,
        ),
      );
    } else if (data['statusIconIndex'] == 2) {
      status = Padding(
        padding: const EdgeInsets.only(left: 5, right: 3),
        child: Icon(
          Icons.cancel,
          color: Colors.grey,
          size: 15,
        ),
      );
    } else if (data['statusIconIndex'] == 3) {
      status = Padding(
        padding: const EdgeInsets.only(left: 5, right: 3),
        child: Icon(
          Icons.cancel,
          color: Colors.red,
          size: 15,
        ),
      );
    }
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      shape: Border(),
      elevation: 3,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 6, 6, 6),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          'الطلب رقم #${data['number']}',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          '${date.year}/${date.month}/${date.day}',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 12, right: 6),
                        child: Text(
                          '${data['productsPrice'] + data['delivery']} ريال',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  if (data['products'].length > 0)
                    productWidget(data['products'][0]),
                  if (data['products'].length > 1)
                    productWidget(data['products'][1]),
                  if (data['products'].length > 2)
                    productWidget(data['products'][2]),
                ],
              ),
              Row(children: <Widget>[
                status,
                Text(
                  data['statusMessage'],
                  style: TextStyle(fontSize: 14),
                )
              ])
            ],
          ),
        ),
      ),
    );
  }

  Widget productWidget(data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ImageFade(
        image: NetworkImage(data['image']),
        errorBuilder: (BuildContext context, Widget child, dynamic exception) {
          return Container(
            color: Colors.grey.withOpacity(0.2),
            child: Center(
                child:
                    Icon(Icons.broken_image, color: Colors.grey, size: 128.0)),
          );
        },
        loadingBuilder:
            (BuildContext context, Widget child, ImageChunkEvent event) {
          return Container(
            color: Colors.grey.withOpacity(0.2),
            child: SpinKitDoubleBounce(
              color: Colors.white,
            ),
          );
        },
        fit: BoxFit.contain,
        width: 80,
      ),
    );
  }
}

NoOrders() => Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Mdi.cartRemove,
            color: Colors.grey.withOpacity(0.6),
            size: 100,
          ),
          TextWidget('لاتوجد أي طلبات',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ))
        ],
      ),
    );
