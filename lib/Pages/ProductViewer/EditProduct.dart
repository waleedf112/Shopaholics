import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Classes/Product.dart';
import '../../Functions/Translation.dart';
import '../../Widgets/CustomDialog.dart';
import '../../Widgets/SecondaryView.dart';
import '../../Widgets/loadingDialog.dart';

class EditProduct extends StatefulWidget {
  ProductOffer product;
  EditProduct(this.product);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  GlobalKey<FormState> formKey = new GlobalKey();
  TextEditingController productNameController;
  TextEditingController productDescController;
  TextEditingController productPriceController;

  @override
  void initState() {
    productNameController = new TextEditingController(text: widget.product.productName);
    productDescController = new TextEditingController(text: widget.product.productDescription);
    productPriceController = new TextEditingController(text: widget.product.productPrice.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: widget.product.productName,
      fab: FloatingActionButton(
        heroTag: 'heroProduct',
        elevation: 1,
        backgroundColor: Colors.green,
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () async {
          FocusScope.of(context).unfocus();
          if (formKey.currentState.validate()) {
            await loadingScreen(
                context: context,
                function: () async {
                  await Firestore.instance
                      .collection('ProductOffer')
                      .document(widget.product.reference.split('/')[1])
                      .updateData({
                    'productName': productNameController.text.trim(),
                    'productDescription': productDescController.text.trim(),
                    'productPrice': int.parse(productPriceController.text.trim()),
                  }).whenComplete(() {
                    Navigator.of(context).pop();
                    CustomDialog(
                        context: context,
                        title: textTranslation(ar: 'تم التعديل', en: 'Done editing'),
                        content: AutoSizeText(
                            textTranslation(ar: 'تم تعديل المنتج بنجاح!', en: 'You have edited your product')),
                        dismissible: false,
                        firstButtonColor: Colors.black45,
                        firstButtonText: textTranslation(ar: 'حسناً', en: 'OK'),
                        firstButtonFunction: () {
                          Navigator.of(context).pop();
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
                            return textTranslation(ar: 'اسم المنتج فارغ!', en: 'Product name is empty');
                          }
                        },
                        decoration: InputDecoration(
                          labelText: textTranslation(ar: 'اسم المنتج', en: 'Product Name'),
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
                          labelText: textTranslation(ar: 'الوصف', en: 'Description'),
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
                            if (x < 1)
                              return textTranslation(ar: 'السعر اقل من ريال واحد', en: 'Price is lower than 1 SR');
                            if (x > 99999)
                              return textTranslation(
                                  ar: 'السعر اعلى من المسموح به', en: 'Price is more than the allowed value');
                          } catch (e) {
                            return textTranslation(ar: 'السعر غير صحيح', en: 'Price is invalid');
                          }
                        },
                        decoration: InputDecoration(
                          labelText: textTranslation(ar: 'السعر', en: 'Price'),
                          labelStyle: TextStyle(fontSize: 14),
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
