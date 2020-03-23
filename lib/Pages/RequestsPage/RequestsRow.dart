import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Functions/PagePush.dart';
import 'package:shopaholics/Pages/RequestsPage/RequestsPage.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/CustomStreamBuilder.dart';
import 'package:shopaholics/Widgets/GridProducts.dart';
import 'package:shopaholics/Widgets/ListProducts.dart';
import 'package:shopaholics/Widgets/ProductWidget.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';

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
              textDirection: TextDirection.rtl,
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
                            text: 'عرض الكل',
                            function: () {
                              PagePush(
                                context,
                                SecondaryView(
                                  title: title,
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
                        return ProductWidget(
                          item: _product,
                          liked: false,
                          requestType: requestType
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
    );
  }
}
