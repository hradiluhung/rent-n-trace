// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lat_lng.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class LatLng extends $LatLng with RealmEntity, RealmObjectBase, RealmObject {
  LatLng(
    double latitude,
    double longitude,
  ) {
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'longitude', longitude);
  }

  LatLng._();

  @override
  double get latitude =>
      RealmObjectBase.get<double>(this, 'latitude') as double;
  @override
  set latitude(double value) => RealmObjectBase.set(this, 'latitude', value);

  @override
  double get longitude =>
      RealmObjectBase.get<double>(this, 'longitude') as double;
  @override
  set longitude(double value) => RealmObjectBase.set(this, 'longitude', value);

  @override
  Stream<RealmObjectChanges<LatLng>> get changes =>
      RealmObjectBase.getChanges<LatLng>(this);

  @override
  Stream<RealmObjectChanges<LatLng>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<LatLng>(this, keyPaths);

  @override
  LatLng freeze() => RealmObjectBase.freezeObject<LatLng>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'latitude': latitude.toEJson(),
      'longitude': longitude.toEJson(),
    };
  }

  static EJsonValue _toEJson(LatLng value) => value.toEJson();
  static LatLng _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'latitude': EJsonValue latitude,
        'longitude': EJsonValue longitude,
      } =>
        LatLng(
          fromEJson(latitude),
          fromEJson(longitude),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(LatLng._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, LatLng, 'LatLng', [
      SchemaProperty('latitude', RealmPropertyType.double),
      SchemaProperty('longitude', RealmPropertyType.double),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
