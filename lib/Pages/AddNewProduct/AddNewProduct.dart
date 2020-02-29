import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';
import 'dart:io';

class AppNewProduct extends StatelessWidget {
  GlobalKey<FormState> formKey = new GlobalKey();
  TextEditingController productNameController = new TextEditingController();
  TextEditingController productDescController = new TextEditingController();
  TextEditingController productPriceController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'اضافة منتج جديد',
      fab: FloatingActionButton(
        elevation: 1,
        backgroundColor: Colors.green,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          FocusScope.of(context).unfocus();
          if (formKey.currentState.validate()) {
            ProductOffer _product = new ProductOffer(
              productName: productNameController.text.trim(),
              productDescription: productDescController.text.trim(),
              productPrice: int.parse(productPriceController.text),
            );
            await loadingScreen(
                context: context,
                function: () async {
                  await _product.pushToDatabase().whenComplete(() {
                    Navigator.of(context).pop();
                    CustomDialog(
                        context: context,
                        title: 'تم اضافة المنتج',
                        content: AutoSizeText('تم اضافة المنتج بنجاح!'),
                        dismissible: false,
                        firstButtonColor: Colors.black45,
                        firstButtonText: 'حسناً',
                        firstButtonFunction: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        });
                  });
                });
          }
        },
      ),
      child: Form(
        key: formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 90,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        textDirection: TextDirection.ltr,
                        controller: productNameController,
                        validator: (String value) {
                          if (value.trim().isEmpty) {
                            return 'اسم المنتج فارغ!';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'اسم المنتج',
                          labelStyle: TextStyle(fontSize: 14),
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //height: 90,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        textDirection: TextDirection.ltr,
                        maxLines: 5,
                        controller: productDescController,
                        validator: (String value) => null,
                        decoration: InputDecoration(
                          labelText: 'الوصف',
                          labelStyle: TextStyle(fontSize: 14),
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 90,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        textDirection: TextDirection.ltr,
                        controller: productPriceController,
                        keyboardType: TextInputType.number,
                        validator: (String value) {
                          try {
                            int x = int.parse(value);
                            if (x < 1) return 'السعر اقل من ريال واحد';
                            if (x > 99999) return 'السعر اعلى من المسموح به';
                          } catch (e) {
                            return 'السعر غير صحيح';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'السعر',
                          labelStyle: TextStyle(fontSize: 14),
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextWidget('الصور', minFontSize: 20, maxFontSize: 23),
                          IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.green,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                  height: 300,
                child: ListView.builder(
                  itemCount: 3,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Placeholder(
                        fallbackWidth: 200,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
