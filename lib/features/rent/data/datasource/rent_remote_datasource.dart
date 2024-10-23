import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/constants/rent_status.dart';
import 'package:rent_n_trace/core/common/models/rent_creation_req.dart';
import 'package:rent_n_trace/core/error/failure.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/rent/data/models/rent_history_model.dart';
import 'package:rent_n_trace/features/rent/data/models/rent_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RentRemoteDatasource {
  // Rent
  Future<Either> getLatestRent();
  Future<Either> getDetailRent(String id);
  Future<Either> createRent(RentCreationReq rent);
  Future<Either> cancelRent(String id);

  // Rent History
  Future<Either> getCurrMonthRentHistories();
  Future<Either> getAllRentHistories();
  Future<Either> getDetailRentHistory(String id);
}

class RentRemoteDatasrouceImpl extends RentRemoteDatasource {
  // Rent
  @override
  Future<Either> getLatestRent() async {
    try {
      final latestRent = await sl<SupabaseClient>()
          .from('rents')
          .select('*, cars (name, image)')
          .order('created_at', ascending: false)
          .limit(1);

      if (latestRent.isEmpty) {
        return const Right(null);
      }

      return Right(RentModel.fromMap(latestRent.first));
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either> getDetailRent(String id) async {
    try {
      final rent = await sl<SupabaseClient>()
          .from('rents')
          .select(
              "*, cars(name, image, fuel_type, fuel_consumption), profiles(full_name), drivers(name, photo)")
          .eq('id', id)
          .limit(1);

      final rejectMessage = await sl<SupabaseClient>()
          .from('reject_messages')
          .select('message')
          .eq('rent_id', rent.first['id'])
          .limit(1);

      print("Reject Message: $rejectMessage");

      if (rent.isEmpty) {
        return Left(Failure('Peminjaman tidak ditemukan'));
      }

      RentModel? rentModel = RentModel.fromMap(rent.first);

      if (rejectMessage.isNotEmpty) {
        rentModel = rentModel.copyWith(rejectMessage: rejectMessage.first['message']);
      }

      return Right(rentModel);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either> createRent(RentCreationReq rent) async {
    try {
      await sl<SupabaseClient>().from('rents').insert({
        'user_id': rent.userId,
        'car_id': rent.carId,
        'driver_id': rent.driverId,
        'start_date': rent.startDate!.toIso8601String(),
        'end_date': rent.endDate!.toIso8601String(),
        'destination': rent.destination,
        'need': rent.need,
        'need_detail': rent.needDetail,
      });

      return const Right("Berhasil mengajukan peminjaman");
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return const Left("Silakan coba lagi!");
    }
  }

  @override
  Future<Either> cancelRent(String id) async {
    try {
      await sl<SupabaseClient>().from('rents').delete().eq('id', id);

      return const Right("Berhasil membatalkan peminjaman");
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return const Left("Silakan coba lagi!");
    }
  }

  // Rent History
  @override
  Future<Either> getCurrMonthRentHistories() async {
    try {
      final startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
      final endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 1)
          .subtract(const Duration(days: 1));

      final rentsHistories = await sl<SupabaseClient>()
          .from('rent_histories')
          .select('*, rents(*, cars (name, image))')
          .eq('rents.status', RentStatus.completed)
          .gte('rents.created_at', startDate.toIso8601String())
          .lte('rents.created_at', endDate.toIso8601String());

      final filteredRentsHistories =
          rentsHistories.where((rentHistory) => rentHistory['rents'] != null).toList();

      return Right(filteredRentsHistories.map((rh) => RentHistoryModel.fromMap(rh)).toList());
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either> getAllRentHistories() async {
    try {
      final rentsHistories = await sl<SupabaseClient>()
          .from('rent_histories')
          .select('*, rents(*, cars (name, image), drivers(name, photo))');

      return Right(rentsHistories.map((rh) => RentHistoryModel.fromMap(rh)).toList());
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either> getDetailRentHistory(String id) async {
    try {
      final rentHistory = await sl<SupabaseClient>()
          .from('rent_histories')
          .select('*, rents(*, cars (*), drivers(name, photo))')
          .eq('id', id);

      if (rentHistory.isEmpty) {
        return Left(Failure('Peminjaman tidak ditemukan'));
      }

      return Right(RentHistoryModel.fromMap(rentHistory.first));
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
