import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_webservice/distance.dart';

import '../Classes/User.dart';
import '../main.dart';
import 'Translation.dart';

Future<Location> getUserLocation(String uid) async {
  return await Firestore.instance.collection('Users').document(uid).get().then((onValue) {
    Map data = onValue.data['location'];
    if (data == null) throw null;
    Location location = new Location(data['lat'], data['lng']);
    return location;
  });
}

Future<String> calculateDistance(String uid) async {
  final GoogleDistanceMatrix distanceMatrix = GoogleDistanceMatrix(apiKey: mapApi);
  Location userLocation = Location(currentUser.location['lat'], currentUser.location['lng']);
  Location sellerLocation;
  sellerLocation = (await getUserLocation(uid));
  DistanceResponse result = (await distanceMatrix.distanceWithLocation([userLocation], [sellerLocation]));
  return result.results[0].elements[0].distance.text.split(' ')[0] + ' ${textTranslation(ar:'كيلو',en:'Km')}';
}
