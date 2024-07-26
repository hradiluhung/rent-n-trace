import 'package:realm/realm.dart';
import 'package:rent_n_trace/features/tracking/data/models/realm/lat_lng.dart';
import 'package:rent_n_trace/features/tracking/data/models/realm/local_locations.dart';

class RealmConfig {
  static final RealmConfig _instance = RealmConfig._internal();

  factory RealmConfig() {
    return _instance;
  }

  RealmConfig._internal();

  Realm? _realm;

  Realm getRealm() {
    if (_realm == null) {
      final config = Configuration.local(
        [LocalLocations.schema, LatLng.schema],
      );
      _realm = Realm(config);
    }
    return _realm!;
  }
}
