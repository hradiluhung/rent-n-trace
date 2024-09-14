import 'package:realm/realm.dart';
import 'package:rent_n_trace/core/common/realm/models/lat_lang.dart';

part 'location_tracking_record.realm.dart';

@RealmModel()
class _LocationTrackingRecord {
  late List<$LatLng> locations;
  late DateTime timestamp;
  late double distance;
}
