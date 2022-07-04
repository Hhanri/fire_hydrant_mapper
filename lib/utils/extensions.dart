import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension GeoFireFromLatLng on LatLng {
  GeoFirePoint geoFireFromLatLng() {
    return GeoFirePoint(latitude, longitude);
  }
}

extension GeoFireFromGeoPoint on GeoPoint {
  GeoFirePoint geoFireFromGeoPoint() {
    return GeoFirePoint(latitude, longitude);
  }
}

extension GeoFireFromPosition on Position{
  GeoFirePoint geoFireFromPosition() {
    return GeoFirePoint(latitude, longitude);
  }
}

extension LatLngFromGeoFire on GeoFirePoint {
  LatLng latLngFromGeoFire() {
    return LatLng(latitude, longitude);
  }
}

extension LatlngFromPosition on Position {
  LatLng latLngFromPosition() {
    return LatLng(latitude, longitude);
  }
}