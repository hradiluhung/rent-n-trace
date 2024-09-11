class RentCreationReq {
  DateTime? startDate;
  DateTime? endDate;
  String? userId;
  String? need;
  String? needDetail;
  String? driverId;
  String? carId;
  String? destination;

  RentCreationReq({
    this.startDate,
    this.endDate,
    this.userId,
    this.need,
    this.needDetail,
    this.driverId,
    this.carId,
    this.destination,
  });
}
