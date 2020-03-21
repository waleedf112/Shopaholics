import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopaholics/Classes/User.dart';

import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';

import '../../../main.dart';

class AddressesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'عنوان التوصيل',
      child: PlacePicker(
        apiKey: mapApi,
        initialPosition: currentUser.location == null
            ? LatLng(24.694788, 46.730772)
            : LatLng(
                currentUser.location['lat'],
                currentUser.location['lng'],
              ),
        useCurrentLocation: currentUser.location == null,
        hideBackButton: true,
        autocompleteLanguage: "ar",
        region: 'sa',
        selectInitialPosition: true,
        selectedPlaceWidgetBuilder:
            (_, selectedPlaceT, state, isSearchBarFocused) {
          return isSearchBarFocused
              ? Container()
              : FloatingCard(
                  bottomPosition: 35.0,
                  leftPosition: 50.0,
                  rightPosition: 50.0,
                  width: 500,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SimpleButton(
                      state == SearchingState.Searching
                          ? 'جاري التحميل ...'
                          : 'تحديد الموقع',
                      function: () {
                        CustomDialog(
                          context: context,
                          title: 'حفظ الموقع',
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'هل انت متأكد انك تريد حفظ الموقع؟\n',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                selectedPlaceT.formattedAddress,
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.ltr,
                              )
                            ],
                          ),
                          firstButtonColor: Colors.black54,
                          firstButtonText: 'حفظ الموقع',
                          secondButtonText: 'تراجع',
                          secondButtonColor: Colors.red,
                          firstButtonFunction: () {
                            Navigator.of(context).pop();
                            loadingScreen(
                                context: context,
                                function: () {
                                  currentUser
                                      .setLocation(
                                          selectedPlaceT.geometry.location)
                                      .whenComplete(() {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  });
                                });
                          },
                          secondButtonFunction: () =>
                              Navigator.of(context).pop(),
                        );
                      },
                    ),
                  ),
                );
        },
        pinBuilder: (context, state) {
          if (state == PinState.Idle) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 60,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Icon(
                Icons.location_on,
                color: Colors.red.withOpacity(0.7),
                size: 60,
              ),
            );
          }
        },
      ),
    );
  }

  Widget locationRow({String title, String value, IconData icon}) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Icon(
            icon,
            color: Colors.grey.withOpacity(0.7),
          ),
        ),
        Text(title + ': '),
        Text(value),
      ],
    );
  }
}
