import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Classes/Product.dart';
import '../../Classes/User.dart';
import '../../Functions/PagePush.dart';
import '../../Functions/Translation.dart';
import '../../Widgets/Button.dart';
import '../../Widgets/CustomStreamBuilder.dart';
import '../../Widgets/GridProducts.dart';
import '../../Widgets/ListProducts.dart';
import '../../Widgets/ProductWidget.dart';
import '../../Widgets/SecondaryView.dart';
import '../../Widgets/TextWidget.dart';
import 'RequestsPage.dart';

class RequestsRow extends StatelessWidget {
  Query query;
  String title;
  List<int> remove;
  bool removeOwnRequests;
  bool removeOfferdRequests;
  RequestType requestType;
  RequestsRow({
    @required this.query,
    @required this.title,
    this.remove,
    this.removeOwnRequests = false,
    this.removeOfferdRequests = false,
    this.requestType,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: query.getDocuments(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data.documents.isNotEmpty) {
          List<DocumentSnapshot> documents = snapshot.data.documents;
          if (remove != null) documents.removeWhere((test) => remove.contains(test.data['id']));
          if (removeOwnRequests) documents.removeWhere((test) => currentUser.uid == test.data['uid']);
          if (removeOfferdRequests)
            documents.removeWhere((test) {
              if (test.data['pendingTraders'] != null) return test.data['pendingTraders'].contains(currentUser.uid);
              return false;
            });
          return LoadingStreamBuilder(
            hasData: snapshot.hasData,
            loading: documents == null,
            widget: Directionality(
              textDirection: layoutTranslation(),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextWidget(
                          title,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        OutlinedButton(
                            text: textTranslation(ar: 'عرض الكل', en: 'Show All'),
                            function: () {
                              PagePush(
                                context,
                                SecondaryView(
                                  title: title,
                                  child: ListProducts(
                                    list: documents,
                                    gridProductsType: GridProductsType.requests,
                                    requestType: requestType,
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
                        return ProductWidget(item: _product, liked: false, requestType: requestType);
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
    );
  }
}
