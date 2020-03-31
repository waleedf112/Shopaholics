import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_fade/image_fade.dart';
import 'package:shopaholics/Classes/Order.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Pages/ChatsPage/ChatPage.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';

class SalesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'المبيعات',
      child: FutureBuilder(
        future: Firestore.instance.collection('Orders').orderBy('dateTime',descending: true).getDocuments(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<Map> list = new List();
            snapshot.data.documents.forEach((doc) {
              List list2 = new List();
              doc['products'].forEach((p) {
                if (p['sellerUid'] == currentUser.uid)
                  list2.add({
                    'sellerUid': p['sellerUid'],
                    'image': p['image'],
                  });
              });
              if (list2.isNotEmpty)
                list.add({
                  'orderNumber': doc['number'],
                  'dateTime': doc['dateTime'],
                  'products': list2,
                  'statusIconIndex': doc['statusIconIndex'],
                  'statusMessage': doc['statusMessage'],
                  'customerUid': doc['uid'],
                });
            });
            Widget productWidget(data) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ImageFade(
                  image: NetworkImage(data['image']),
                  errorBuilder: (BuildContext context, Widget child, dynamic exception) {
                    return Container(
                      color: Colors.grey.withOpacity(0.2),
                      child: Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 128.0)),
                    );
                  },
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent event) {
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

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                DateTime date = DateTime.fromMillisecondsSinceEpoch(list[index]['dateTime']);
                Widget status;
                if (list[index]['statusIconIndex'] == 0) {
                  status = Padding(
                    padding: const EdgeInsets.only(left: 5, right: 3),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 15,
                    ),
                  );
                } else if (list[index]['statusIconIndex'] == 1) {
                  status = Padding(
                    padding: const EdgeInsets.only(left: 5, right: 3),
                    child: Icon(
                      Icons.pause_circle_filled,
                      color: Colors.orange,
                      size: 15,
                    ),
                  );
                } else if (list[index]['statusIconIndex'] == 2) {
                  status = Padding(
                    padding: const EdgeInsets.only(left: 5, right: 3),
                    child: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 15,
                    ),
                  );
                } else if (list[index]['statusIconIndex'] == 3) {
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
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  elevation: 3,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'الطلب رقم #${list[index]['orderNumber']}',
                                  style: TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                                Text(
                                  '${date.year}/${date.month}/${date.day}',
                                  style: TextStyle(color: Colors.grey, fontSize: 11),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(children: <Widget>[
                          for (int i = 0; i <= 3 && i < list[index]['products'].length; i++)
                            productWidget(list[index]['products'][i])
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, top: 8),
                        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                          OutlinedButton(
                              text: 'ارسال رسالة للزبون',
                              function: () async {
                                await sendPrivateMessage(context, list[index]['customerUid']);
                              }),
                          Expanded(child: Container()),
                          status,
                          Text(
                            list[index]['statusMessage'],
                            style: TextStyle(fontSize: 14),
                          ),
                        ]),
                      )
                    ],
                  ),
                );
              },
            );
          }

          return SpinKitRotatingCircle(
            color: Colors.grey.withOpacity(0.3),
          );
        },
      ),
    );
  }
}
