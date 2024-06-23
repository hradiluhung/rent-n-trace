import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/domain/repositories/rent_repository.dart';

class CreateRent implements UseCase<Rent, CreateRentParams> {
  RentRepository rentRepository;
  CreateRent(this.rentRepository);

  @override
  Future<Either<Failure, Rent>> call(CreateRentParams params) {
    return rentRepository.createRent(
      userId: params.userId,
      startDate: params.startDate,
      endDate: params.endDate,
      destination: params.destination,
      need: params.need,
      needDetail: params.needDetail,
      driverId: params.driverId,
      driverName: params.driverName,
      carId: params.carId,
      carName: params.carName,
    );
  }
}

class CreateRentParams {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final String destination;
  final String need;
  final String needDetail;
  final String? driverId;
  final String? driverName;
  final String? carId;
  final String? carName;

  CreateRentParams({
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.destination,
    required this.need,
    required this.needDetail,
    this.driverId,
    this.driverName,
    this.carId,
    this.carName,
  });
}
