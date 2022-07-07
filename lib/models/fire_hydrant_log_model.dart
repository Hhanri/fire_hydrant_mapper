import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fire_hydrant_mapper/constants/firebase_constants.dart';
import 'package:fire_hydrant_mapper/pages/log_form_page.dart';
import 'package:fire_hydrant_mapper/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FireHydrantLogModel extends Equatable {
  final String? documentId;
  final GeoFirePoint geoPoint;
  final String streetName;
  final List<String> archivesIds;

  const FireHydrantLogModel({
    this.documentId,
    required this.geoPoint,
    required this.streetName,
    required this.archivesIds
  });

  factory FireHydrantLogModel.fromJson(Map<String, dynamic> json) {
    return FireHydrantLogModel(
      documentId: json[FirebaseConstants.documentId],
      geoPoint: (json[FirebaseConstants.position][FirebaseConstants.geopoint] as GeoPoint).geoFireFromGeoPoint(),
      streetName: json[FirebaseConstants.streetName],
      archivesIds: List<String>.from(json[FirebaseConstants.archivesIds])
    );
  }

  static Map<String, dynamic> toJson({required FireHydrantLogModel model}) {
    return {
      FirebaseConstants.documentId: model.geoPoint.hash,
      FirebaseConstants.position: model.geoPoint.data,
      FirebaseConstants.streetName: model.streetName,
      FirebaseConstants.archivesIds: model.archivesIds
    };
  }

  static FireHydrantLogModel emptyLog({required GeoFirePoint geoFirePoint}) {
    return FireHydrantLogModel(
      documentId: geoFirePoint.hash,
      geoPoint: geoFirePoint,
      streetName: "",
      archivesIds: const []
    );
  }
  
  static final FireHydrantLogModel mockData = FireHydrantLogModel(
    documentId: UniqueKey().toString(),
    geoPoint: GeoFirePoint(48.88888737849572, 2.34311714079882),
    streetName: "aucune idee",
    archivesIds: const []
  );

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
  // TODO: implement props
  List<Object?> get props => [documentId, geoPoint, streetName, archivesIds];
}
