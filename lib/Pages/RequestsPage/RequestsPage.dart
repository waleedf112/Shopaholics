import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Classes/Product.dart';
import '../../Classes/User.dart';
import '../../Classes/UserRole.dart';
import '../../Functions/PagePush.dart';
import '../../Functions/Translation.dart';
import '../../Widgets/Button.dart';
import '../../Widgets/CustomStreamBuilder.dart';
import '../../Widgets/GridProducts.dart';
import '../../Widgets/ListProducts.dart';
import '../../Widgets/ProductWidget.dart';
import '../../Widgets/SecondaryView.dart';
import '../../Widgets/TextWidget.dart';
import 'RequestsRow.dart';
import 'noRequestsPage.dart';

enum RequestType {
  myRequest,
  acceptedRequest,
  normal,
}
ValueNotifier<int> updatedRequestsPage = new ValueNotifier<int>(DateTime.now().millisecondsSinceEpoch);

class RequestsPage extends StatelessWidget {
  Widget _buildRequestRow({Widget child, UserRole blockedRoles}) {
    if (isSignedIn() && currentUser.role != blockedRoles) return child;
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    if (!isSignedIn()) return NoRequestsPage();

    return ValueListenableBuilder(
        valueListenable: updatedRequestsPage,
        builder: (BuildContext context, int value, Widget child) {
          return ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              _buildRequestRow(
                blockedRoles: UserRole.customer,
                child: RequestsRow(
                  query: Firestore.instance
                      .collection('ProductRequests')
                      .where('acceptedTrader', isEqualTo: currentUser.uid),
                  title: textTranslation(ar: 'العروض المقبولة', en: ''),
                  requestType: RequestType.acceptedRequest,
                ),
              ),
              _buildRequestRow(
                blockedRoles: UserRole.customer,
                child: RequestsRow(
                    query: Firestore.instance
                        .collection('ProductRequests')
                        .where('pendingTraders', arrayContains: currentUser.uid),
                    title: textTranslation(ar: 'العروض المقدمة', en: ''),
                    requestType: RequestType.normal),
              ),
              _buildRequestRow(
                blockedRoles: UserRole.customer,
                child: RequestsRow(
                    query: Firestore.instance
                        .collection('ProductRequests')
                        .where('acceptedTrader', isNull: true)
                        .orderBy('Time', descending: true),
                    removeOwnRequests: true,
                    removeOfferdRequests: true,
                    title: textTranslation(ar: 'اجدد الطلبات', en: ''),
                    requestType: RequestType.normal),
              ),
              FutureBuilder(
                future: Firestore.instance
                    .collection('ProductRequests')
                    .where('uid', isEqualTo: currentUser.uid)
                    .orderBy('Time', descending: true)
                    .where('acceptedTrade', isNull: true)
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
                                    textTranslation(ar: 'طلباتي', en: ''),
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  OutlinedButton(
                                      text: textTranslation(ar: 'عرض الكل', en: ''),
                                      function: () {
                                        PagePush(
                                          context,
                                          SecondaryView(
                                            title: textTranslation(ar: 'طلباتي', en: ''),
                                            child: ListProducts(
                                              list: documents,
                                              gridProductsType: GridProductsType.requests,
                                              requestType: RequestType.myRequest,
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
                                        child: ProductWidget(
                                            item: _product,
                                            liked: false,
                                            isMyRequest: true,
                                            requestType: RequestType.myRequest),
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
                    return Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Container(),
                    );
                  }
                },
              ),
            ],
          );
        });
  }
}
