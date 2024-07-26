import 'package:realm/realm.dart';
import 'package:rent_n_trace/features/tracking/data/models/realm/lat_lng.dart';

part 'local_locations.realm.dart';

@RealmModel()
class _LocalLocations {
  late List<$LatLng> locations;
  late DateTime timestamp;
  late double distance;
}
