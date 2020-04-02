import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Pages/RequestsPage/RequestsPage.dart';
import 'package:shopaholics/Widgets/GridProducts.dart';
import 'package:shopaholics/Widgets/ListProducts.dart';
import 'package:shopaholics/Widgets/ProductWidget.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';

ValueNotifier<int> updatedMyProductsPage = new ValueNotifier<int>(0);

class MyProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: textTranslation(ar: 'منتجاتي', en: ''),
      child: ValueListenableBuilder(
        valueListenable: updatedMyProductsPage,
        builder: (_, value, child) => StreamBuilder(
          stream: Firestore.instance
              .collection('ProductOffer')
              .where('uid', isEqualTo: currentUser.uid)
              .where('deleted', isEqualTo: false)
              .getDocuments()
              .asStream(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return SpinKitRotatingCircle(color: Colors.grey.withOpacity(0.4));
            return GridView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.documents.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.5),
              itemBuilder: (BuildContext context, int index) {
                ProductOffer _product = new ProductOffer.retrieveFromDatabase(
                  snapshot.data.documents[index].data,
                  snapshot.data.documents[index].reference.path.toString(),
                );
                return ProductWidget(
                  item: _product,
                  liked: false,
                  requestType: RequestType.normal,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
