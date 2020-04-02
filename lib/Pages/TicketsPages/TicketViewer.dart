import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mdi/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Functions/PagePush.dart';
import '../../Functions/Translation.dart';
import '../../Widgets/Button.dart';
import '../../Widgets/SecondaryView.dart';
import '../../Widgets/TextWidget.dart';

class TicketsViewer extends StatefulWidget {
  @override
  _TicketsViewerState createState() => _TicketsViewerState();
}

class _TicketsViewerState extends State<TicketsViewer> {
  String getType(String value) {
    if (value == 'TicketType.orderComplaint') return textTranslation(ar: 'الفاتوره ', en: 'Order ');
    if (value == 'TicketType.requestComplaint') return textTranslation(ar: 'الطلب ', en: 'Request ');
    if (value == 'TicketType.productComplaint') return textTranslation(ar: 'المنتج ', en: 'Product ');
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: textTranslation(ar: 'البلاغات', en: 'Reports'),
      child: StreamBuilder(
        stream: Firestore.instance.collection('Tickets').where('resolved', isEqualTo: false).getDocuments().asStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return SpinKitRotatingCircle(color: Colors.grey.withOpacity(0.3));
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot ticketRef = snapshot.data.documents[index];
              Map data = snapshot.data.documents[index].data;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Card(
                  margin: EdgeInsets.all(0),
                  shape: Border(),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 16, 16),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '#${getType(data['type'])}${data['ref'].split('/')[1]}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                TextWidget(data['info']),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FutureBuilder(
                              future: Firestore.instance.collection('Users').document(data['uid']).get(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (!snapshot.hasData)
                                  return SpinKitRotatingCircle(color: Colors.grey.withOpacity(0.3));
                                return Column(
                                  children: <Widget>[
                                    Text(snapshot.data.data['displayName']),
                                    OutlinedButton(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(textTranslation(ar: 'الاتصال بالزبون', en: 'Call Customer')),
                                                  ],
                                                ),
                                              ),
                                              Icon(Mdi.phoneOutline),
                                            ],
                                          ),
                                        ),
                                        function: () {
                                          try {
                                            launch("tel://${snapshot.data.data['phone']}");
                                          } catch (e) {}
                                        }),
                                    OutlinedButton(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(textTranslation(ar: 'ارسل ايميل للزبون', en: 'Send Email')),
                                                  ],
                                                ),
                                              ),
                                              Icon(Mdi.emailOutline),
                                            ],
                                          ),
                                        ),
                                        function: () async {
                                          try {
                                            await launch('mailto:' + snapshot.data.data['email']);
                                          } catch (e) {
                                            PagePush(
                                                context,
                                                Scaffold(
                                                  appBar: AppBar(
                                                    backgroundColor: Colors.yellow,
                                                    elevation: 0,
                                                  ),
                                                  body: ListView(
                                                    children: <Widget>[
                                                      ErrorWidget(e),
                                                    ],
                                                  ),
                                                ));
                                          }
                                        }),
                                    OutlinedButton(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(textTranslation(ar: 'اغلاق الشكوى', en: 'Close Ticket')),
                                                  ],
                                                ),
                                              ),
                                              Icon(Mdi.closeOutline),
                                            ],
                                          ),
                                        ),
                                        function: () {
                                          ticketRef.reference.updateData({
                                            'resolved': true,
                                          });
                                          setState(() {});
                                        }),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
