import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../Classes/Product.dart';
import '../../Functions/Translation.dart';
import '../../Functions/isEmailVerified.dart';
import '../../Widgets/CustomDialog.dart';
import '../../Widgets/SecondaryView.dart';
import '../../Widgets/TextWidget.dart';
import '../../Widgets/loadingDialog.dart';

class AddProductRequest extends StatefulWidget {
  @override
  _AddProductRequestState createState() => _AddProductRequestState();
}

class _AddProductRequestState extends State<AddProductRequest> {
  List<File> _image = new List();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 8, ratioY: 9),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '',
            hideBottomControls: true,
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black,
            showCropGrid: false,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 9 / 8,
          aspectRatioLockEnabled: true,
        ));
    if (croppedFile != null)
      setState(() {
        _image.add(croppedFile);
      });
  }

  GlobalKey<FormState> formKey = new GlobalKey();
  TextEditingController productNameController = new TextEditingController();
  TextEditingController productDescController = new TextEditingController();
  TextEditingController productPriceController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: textTranslation(ar: 'اضافة طلب جديد', en: ''),
      fab: FloatingActionButton(
        heroTag: 'heroRequest',
        elevation: 0,
        disabledElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        backgroundColor: Colors.green.withOpacity(0.8),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          FocusScope.of(context).unfocus();
          bool isVerified = (await isEmailVerified(context, false));
          if (formKey.currentState.validate() && isVerified && _image.length >= 3 && _image.length < 10) {
            ProductRequest _product = new ProductRequest(
              productName: productNameController.text.trim(),
              productDescription: productDescController.text.trim(),
              productPrice: int.parse(productPriceController.text),
              productImages: _image,
            );
            await loadingScreen(
                context: context,
                function: () async {
                  await _product.pushToDatabase().whenComplete(() {
                    Navigator.of(context).pop();
                    CustomDialog(
                        context: context,
                        title: textTranslation(ar: 'تم اضافة الطلب', en: ''),
                        content: AutoSizeText(textTranslation(ar: 'تم اضافة طلب المنتج بنجاح!', en: '')),
                        dismissible: false,
                        firstButtonColor: Colors.black45,
                        firstButtonText: textTranslation(ar: 'حسناً', en: 'OK'),
                        firstButtonFunction: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        });
                  });
                });
          } else if (formKey.currentState.validate() && _image.length < 3 || _image.length > 10) {
            CustomDialog(
                context: context,
                title: textTranslation(ar: 'خطأ', en: 'Error'),
                content: AutoSizeText(textTranslation(ar: 'الرجاء اضافة من 3 الى 10 صور للمنتج.', en: '')),
                dismissible: false,
                firstButtonColor: Colors.black45,
                firstButtonText: textTranslation(ar: 'حسناً', en: 'OK'),
                firstButtonFunction: () {
                  Navigator.of(context).pop();
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
                            return textTranslation(ar: 'اسم المنتج فارغ!', en: '');
                          }
                        },
                        decoration: InputDecoration(
                          labelText: textTranslation(ar: 'اسم المنتج', en: ''),
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
                          labelText: textTranslation(ar: 'الوصف', en: ''),
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
                            if (x < 1) return textTranslation(ar: 'السعر اقل من ريال واحد', en: '');
                            if (x > 99999) return textTranslation(ar: 'السعر اعلى من المسموح به', en: '');
                          } catch (e) {
                            return textTranslation(ar: 'السعر غير صحيح', en: '');
                          }
                        },
                        decoration: InputDecoration(
                          labelText: textTranslation(ar: 'السعر', en: ''),
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
                          TextWidget(textTranslation(ar: 'الصور', en: ''), minFontSize: 20, maxFontSize: 23),
                          IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.green,
                            ),
                            onPressed: getImage,
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
                child: _image.isNotEmpty
                    ? ListView.builder(
                        itemCount: _image.length,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15), child: Image.file(_image[index])),
                              ),
                              Positioned(
                                top: -10,
                                left: -10,
                                child: IconButton(
                                    icon: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.red[700], borderRadius: BorderRadius.circular(90)),
                                        child: Icon(Icons.remove, color: Colors.white)),
                                    onPressed: () => setState(() => _image.removeAt(index))),
                              ),
                            ],
                          );
                        },
                      )
                    : Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.image,
                              size: 60,
                              color: Colors.grey[300],
                            ),
                          ),
                          Text(
                            textTranslation(ar: 'الرجاء اضافة صور للمنتج', en: ''),
                            style: TextStyle(color: Colors.grey, fontSize: 21),
                          ),
                        ],
                      )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
