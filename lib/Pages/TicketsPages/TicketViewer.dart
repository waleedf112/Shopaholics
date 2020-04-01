import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mdi/mdi.dart';
import 'package:shopaholics/Functions/PagePush.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';
import 'package:url_launcher/url_launcher.dart';

import 'TicketPage.dart';

class TicketsViewer extends StatefulWidget {
  @override
  _TicketsViewerState createState() => _TicketsViewerState();
}

class _TicketsViewerState extends State<TicketsViewer> {
  String getType(String value) {
    if (value == 'TicketType.orderComplaint') return 'الفاتوره ';
    if (value == 'TicketType.requestComplaint') return 'الطلب ';
    if (value == 'TicketType.productComplaint') return 'المنتج ';
  }

  String getEmailSubject(String type, String ref) => '${type}رقم ${ref.split('/')[1]} ';

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'البلاغات',
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
                                                    Text('الاتصال بالزبون'),
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
                                                    Text('ارسل ايميل للزبون'),
                                                  ],
                                                ),
                                              ),
                                              Icon(Mdi.emailOutline),
                                            ],
                                          ),
                                        ),
                                        function: () {
                                          try {
                                            launch(
                                                "mailto:${snapshot.data.data['email']}?subject=بخصوص الشكوى عن ${getEmailSubject(getType(data['type']), data['ref'])}");
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
                                                    Text('اغلاق الشكوى'),
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
