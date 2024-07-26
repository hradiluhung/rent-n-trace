import 'package:rent_n_trace/core/constants/status_constants.dart';
import 'package:rent_n_trace/core/error/exceptions.dart';
import 'package:rent_n_trace/features/tracking/data/models/tracking_history_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class LocationRemoteDatasource {
  Future<String> startTracking({
    required String rentId,
    required double latitude,
    required double longitude,
  });

  Future<String> stopTracking({
    required String rentId,
    required TrackingHistoryModel trackingHistory,
  });
}

class LocationRemoteDatasourceImpl implements LocationRemoteDatasource {
  final SupabaseClient supabaseClient;

  LocationRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<String> startTracking({
    required String rentId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final rentResponse = await supabaseClient.from("rents").select("status").eq("id", rentId).single();

      final rentStatus = rentResponse["status"];

      if (rentStatus != RentStatus.tracked) {
        await supabaseClient.from("rents").update(
          {
            "status": RentStatus.tracked,
          },
        ).eq("id", rentId);
      }

      await supabaseClient.from("real_time_locations").update(
        {
          "latitude": latitude,
          "longitude": longitude,
          "is_tracking": true,
        },
      ).eq("rent_id", rentId);

      return "Tracking sedang berjalan";
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> stopTracking({
    required String rentId,
    required TrackingHistoryModel trackingHistory,
  }) async {
    try {
      await supabaseClient.from("rents").update(
        {
          "status": RentStatus.done,
        },
      ).eq("id", rentId);

      await supabaseClient.from("real_time_locations").update(
        {
          "is_tracking": false,
        },
      ).eq("rent_id", rentId);

      await supabaseClient.from("tracking_histories").insert(
            trackingHistory.toJson(),
          );

      return "Tracking selesai";
    } catch (e) {
      print("Error: $e");
      throw ServerException(e.toString());
    }
  }
}
