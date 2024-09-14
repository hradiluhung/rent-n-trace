// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_tracking_record.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class LocationTrackingRecord extends _LocationTrackingRecord
    with RealmEntity, RealmObjectBase, RealmObject {
  LocationTrackingRecord(
    DateTime timestamp,
    double distance, {
    Iterable<LatLng> locations = const [],
  }) {
    RealmObjectBase.set<RealmList<LatLng>>(
        this, 'locations', RealmList<LatLng>(locations));
    RealmObjectBase.set(this, 'timestamp', timestamp);
    RealmObjectBase.set(this, 'distance', distance);
  }

  LocationTrackingRecord._();

  @override
  RealmList<LatLng> get locations =>
      RealmObjectBase.get<LatLng>(this, 'locations') as RealmList<LatLng>;
  @override
  set locations(covariant RealmList<LatLng> value) =>
      throw RealmUnsupportedSetError();

  @override
  DateTime get timestamp =>
      RealmObjectBase.get<DateTime>(this, 'timestamp') as DateTime;
  @override
  set timestamp(DateTime value) =>
      RealmObjectBase.set(this, 'timestamp', value);

  @override
  double get distance =>
      RealmObjectBase.get<double>(this, 'distance') as double;
  @override
  set distance(double value) => RealmObjectBase.set(this, 'distance', value);

  @override
  Stream<RealmObjectChanges<LocationTrackingRecord>> get changes =>
      RealmObjectBase.getChanges<LocationTrackingRecord>(this);

  @override
  Stream<RealmObjectChanges<LocationTrackingRecord>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<LocationTrackingRecord>(this, keyPaths);

  @override
  LocationTrackingRecord freeze() =>
      RealmObjectBase.freezeObject<LocationTrackingRecord>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'locations': locations.toEJson(),
      'timestamp': timestamp.toEJson(),
      'distance': distance.toEJson(),
    };
  }

  static EJsonValue _toEJson(LocationTrackingRecord value) => value.toEJson();
  static LocationTrackingRecord _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'timestamp': EJsonValue timestamp,
        'distance': EJsonValue distance,
      } =>
        LocationTrackingRecord(
          fromEJson(timestamp),
          fromEJson(distance),
          locations: fromEJson(ejson['locations']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(LocationTrackingRecord._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, LocationTrackingRecord,
        'LocationTrackingRecord', [
      SchemaProperty('locations', RealmPropertyType.object,
          linkTarget: 'LatLng', collectionType: RealmCollectionType.list),
      SchemaProperty('timestamp', RealmPropertyType.timestamp),
      SchemaProperty('distance', RealmPropertyType.double),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
