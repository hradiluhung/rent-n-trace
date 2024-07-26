import 'package:realm/realm.dart';

part 'lat_lng.realm.dart';

@RealmModel()
class $LatLng {
  late double latitude;
  late double longitude;
}
