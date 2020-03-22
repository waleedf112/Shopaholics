import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Classes/UserRole.dart';
import 'package:shopaholics/Functions/PagePush.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/CustomStreamBuilder.dart';
import 'package:shopaholics/Widgets/GridProducts.dart';
import 'package:shopaholics/Widgets/ListProducts.dart';
import 'package:shopaholics/Widgets/ProductWidget.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';

import 'RequestsRow.dart';
import 'noRequestsPage.dart';

ValueNotifier<TimeOfDay> updatedRequestsPage = new ValueNotifier<TimeOfDay>(TimeOfDay.now());

class RequestsPage extends StatelessWidget {
  Widget _buildRequestRow({Widget child, UserRole blockedRoles}) {
    if (isSignedIn() && currentUser.role != blockedRoles) return child;
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    if (!isSignedIn()) return NoRequestsPage();
    List<int> madeAnOfferList = new List();

    return ValueListenableBuilder(
        valueListenable: updatedRequestsPage,
        builder: (BuildContext context, TimeOfDay value, Widget child) {
          return ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              _buildRequestRow(
                blockedRoles: UserRole.customer,
                child: RequestsRow(
                  query: Firestore.instance
                      .collection('ProductRequests')
                      .where('acceptedTrader', isEqualTo: currentUser.uid),
                  title: 'العروض المقبولة',
                ),
              ),
              _buildRequestRow(
                blockedRoles: UserRole.customer,
                child: FutureBuilder(
                  future: Firestore.instance.collectionGroup('offers').getDocuments(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data.documents.isNotEmpty) {
                      snapshot.data.documents.forEach((f) {
                        madeAnOfferList.add(f.data['requestId']);
                      });
                      return RequestsRow(
                        query: Firestore.instance
                            .collection('ProductRequests')
                            .where('acceptedTrader', isNull: true)
                            .where('id', whereIn: madeAnOfferList),
                        title: 'العروض المقدمة',
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              _buildRequestRow(
                blockedRoles: UserRole.customer,
                child: RequestsRow(
                  query: Firestore.instance
                      .collection('ProductRequests')
                      .where('acceptedTrader', isNull: true)
                      .orderBy('Time', descending: true),
                  remove: madeAnOfferList,
                  removeOwnRequests: true,
                  title: 'اجدد العروض',
                ),
              ),
              FutureBuilder(
                future: Firestore.instance
                    .collection('ProductRequests')
                    .where('uid', isEqualTo: currentUser.uid)
                    .orderBy('Time', descending: true)
                    .getDocuments(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.data.documents.isNotEmpty) {
                    List<DocumentSnapshot> documents = snapshot.data.documents;
                    return LoadingStreamBuilder(
                      hasData: snapshot.hasData,
                      loading: documents == null,
                      widget: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  TextWidget(
                                    'طلباتي',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  OutlinedButton(
                                      text: 'عرض الكل',
                                      function: () {
                                        PagePush(
                                          context,
                                          SecondaryView(
                                            title: 'طلباتي',
                                            child: ListProducts(
                                              list: documents,
                                              gridProductsType: GridProductsType.requests,
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                            Container(
                              height: 350,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: documents == null ? 0 : documents.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  ProductRequest _product = new ProductRequest.retrieveFromDatabase(
                                    documents[index].data,
                                    documents[index].reference.path,
                                  );
                                  return Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: ProductWidget(_product, false, true),
                                      ),
                                      FutureBuilder(
                                        future: Firestore.instance
                                            .collection('ProductRequests')
                                            .document(_product.reference.split('/')[1])
                                            .collection('offers')
                                            .getDocuments(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasData && snapshot.data.documents.isNotEmpty)
                                            return Positioned(
                                              left: 0,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.red[500],
                                                radius: 12,
                                                child: Text(
                                                  snapshot.data.documents.length.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );

                                          return Container();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          );
        });
  }
}
