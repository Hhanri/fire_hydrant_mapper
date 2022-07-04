import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_archive_model.dart';
import 'package:fire_hydrant_mapper/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FireHydrantLogModel extends Equatable {
  final String? documentId;
  final GeoFirePoint geoPoint;
  final String streetName;
  final List<FireHydrantArchiveModel> archives;

  const FireHydrantLogModel({
    this.documentId,
    required this.geoPoint,
    required this.streetName,
    required this.archives
  });

  factory FireHydrantLogModel.fromJson(Map<String, dynamic> json) {
    return FireHydrantLogModel(
      documentId: json['documentId'],
      geoPoint: (json['position']['geopoint'] as GeoPoint).geoFireFromGeoPoint(),
      streetName: json['streetName'],
      archives: List<FireHydrantArchiveModel>.from(json['archives'].map((archive) => FireHydrantArchiveModel.fromJson(archive)))
    );
  }

  static Map<String, dynamic> toJson({required FireHydrantLogModel model}) {
    return {
      'documentId': model.geoPoint.hash,
      'position': model.geoPoint.data,
      'streetName': model.streetName,
      'archives': model.archives.map((archive) => FireHydrantArchiveModel.toJson(archive)).toList()
    };
  }

  static FireHydrantLogModel emptyLog({required GeoFirePoint geoPoint}) {
    return FireHydrantLogModel(
      documentId: geoPoint.hash,
      geoPoint: geoPoint,
      streetName: "",
      archives: const []
    );
  }

  static final FireHydrantLogModel mockData = FireHydrantLogModel(
    documentId: UniqueKey().toString(),
    geoPoint: GeoFirePoint(48.88888737849572, 2.34311714079882),
    streetName: "aucune idee",
    archives: FireHydrantArchiveModel.mockData
  );

  static Marker getMarker({required BuildContext context, required FireHydrantLogModel log}) {
    return Marker(
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
  List<Object?> get props => [documentId, geoPoint, streetName, archives];
}
