import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fire_hydrant_mapper/constants/firebase_constants.dart';
import 'package:fire_hydrant_mapper/pages/log_form_page.dart';
import 'package:fire_hydrant_mapper/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FireHydrantLogModel extends Equatable {
  final String logId;
  final GeoFirePoint geoPoint;
  final String streetName;

  const FireHydrantLogModel({
    required this.logId,
    required this.geoPoint,
    required this.streetName,
  });

  factory FireHydrantLogModel.fromJson(Map<String, dynamic> json) {
    return FireHydrantLogModel(
      logId: json[FirebaseConstants.logId],
      geoPoint: (json[FirebaseConstants.position][FirebaseConstants.geopoint] as GeoPoint).geoFireFromGeoPoint(),
      streetName: json[FirebaseConstants.streetName],
    );
  }

  static Map<String, dynamic> toJson({required FireHydrantLogModel model}) {
    return {
      FirebaseConstants.logId: model.geoPoint.hash,
      FirebaseConstants.position: model.geoPoint.data,
      FirebaseConstants.streetName: model.streetName,
    };
  }

  static FireHydrantLogModel emptyLog({required GeoFirePoint geoFirePoint}) {
    return FireHydrantLogModel(
      logId: geoFirePoint.hash,
      geoPoint: geoFirePoint,
      streetName: "",
    );
  }

  static Marker getMarker({required BuildContext context, required FireHydrantLogModel log}) {
    return Marker(
      markerId: MarkerId(log.geoPoint.hash),
      position: log.geoPoint.latLngFromGeoFire(),
      infoWindow: InfoWindow(title: log.streetName),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LogFormPage(initialLog: log)
          )
        );
      }
    );
  }
  
  static Marker getTempMarker({required BuildContext context, required FireHydrantLogModel log}) {
    return Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(100),
      markerId: MarkerId(log.geoPoint.hash),
      position: log.geoPoint.latLngFromGeoFire(),
      infoWindow: InfoWindow(title: log.streetName),
      onTap: () {
        //navigate to logs page
      }
    );
  }

  static Set<Marker> getMarkers({required BuildContext context, required List<FireHydrantLogModel> logs}) {
    final Set<Marker> markers = logs.map((log) {
      return getMarker(context: context, log: log);
    }).toSet();
    return markers;
  }

  @override
  List<Object?> get props => [logId, geoPoint, streetName];
}
