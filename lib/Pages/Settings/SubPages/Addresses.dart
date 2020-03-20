import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';

class AddressesPage extends StatefulWidget {
  static final kInitialPosition = LatLng(24.694788, 46.730772);

  @override
  _AddressesPageState createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  ValueNotifier<PickResult> selectedPlace = ValueNotifier<PickResult>(null);

  @override
  Widget build(BuildContext context) {
    Widget mapsWidget() {
      return PlacePicker(
        apiKey: 'AIzaSyBbG6iid8fXmD36E8eKIMJX9YVTE1gdyMI',
        initialPosition: AddressesPage.kInitialPosition,
        useCurrentLocation: true,
        hideBackButton: true,
        autocompleteLanguage: "ar",
        region: 'sa',
        selectInitialPosition: true,
        selectedPlaceWidgetBuilder: (_, selectedPlaceT, state, isSearchBarFocused) {
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
                      state == SearchingState.Searching ? 'جاري التحميل ...' : 'تحديد الموقع',
                      function: () {
                        selectedPlace.value = selectedPlaceT;
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
      );
    }

    return SecondaryView(
      title: 'عنوان التوصيل',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 2, child: mapsWidget()),
            Expanded(
              child: Column(
                children: <Widget>[
                  ValueListenableBuilder(
                    valueListenable: selectedPlace,
                    builder: (BuildContext context, PickResult value, Widget child) {
                      if (value == null) return Container();
                      return Text(value.formattedAddress.toString());
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
