import 'package:rent_n_trace/core/error/exceptions.dart';
import 'package:rent_n_trace/features/tracking/data/models/location_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class LocationRemoteDatasource {
  Stream<LocationModel> getRealTimeLocation(String rentId);
}

class LocationRemoteDatasourceImpl implements LocationRemoteDatasource {
  final SupabaseClient supabaseClient;

  LocationRemoteDatasourceImpl(this.supabaseClient);

  @override
  Stream<LocationModel> getRealTimeLocation(String rentId) {
    try {
      final location = supabaseClient
          .from('real_time_locations')
          .stream(primaryKey: ['id']).map(
        (data) {
          print("Data: $data");
          return LocationModel.fromJson(data.first);
        },
      );

      location.listen((event) {
        print("Event: $event");
        print("Latitude: ${event.latitude}");
      }).onError((error, stackTrace) {
        print("Error: $error");
        print("Stacktrace: $stackTrace");
      });

      print("Location: $location");
      return location;
    } catch (e) {
      print("Error: $e");
      throw ServerException(e.toString());
    }
  }
}
