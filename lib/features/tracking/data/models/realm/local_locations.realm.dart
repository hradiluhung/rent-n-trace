// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_locations.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class LocalLocations extends _LocalLocations
    with RealmEntity, RealmObjectBase, RealmObject {
  LocalLocations(
    DateTime timestamp,
    double distance, {
    Iterable<LatLng> locations = const [],
  }) {
    RealmObjectBase.set<RealmList<LatLng>>(
        this, 'locations', RealmList<LatLng>(locations));
    RealmObjectBase.set(this, 'timestamp', timestamp);
    RealmObjectBase.set(this, 'distance', distance);
  }

  LocalLocations._();

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
  Stream<RealmObjectChanges<LocalLocations>> get changes =>
      RealmObjectBase.getChanges<LocalLocations>(this);

  @override
  Stream<RealmObjectChanges<LocalLocations>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<LocalLocations>(this, keyPaths);

  @override
  LocalLocations freeze() => RealmObjectBase.freezeObject<LocalLocations>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'locations': locations.toEJson(),
      'timestamp': timestamp.toEJson(),
      'distance': distance.toEJson(),
    };
  }

  static EJsonValue _toEJson(LocalLocations value) => value.toEJson();
  static LocalLocations _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'locations': EJsonValue locations,
        'timestamp': EJsonValue timestamp,
        'distance': EJsonValue distance,
      } =>
        LocalLocations(
          fromEJson(timestamp),
          fromEJson(distance),
          locations: fromEJson(locations),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(LocalLocations._);
    register(_toEJson, _fromEJson);
    return SchemaObject(
        ObjectType.realmObject, LocalLocations, 'LocalLocations', [
      SchemaProperty('locations', RealmPropertyType.object,
          linkTarget: 'LatLng', collectionType: RealmCollectionType.list),
      SchemaProperty('timestamp', RealmPropertyType.timestamp),
      SchemaProperty('distance', RealmPropertyType.double),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
