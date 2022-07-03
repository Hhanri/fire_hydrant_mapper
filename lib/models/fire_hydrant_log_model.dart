import 'package:equatable/equatable.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_archive_model.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FireHydrantLogModel extends Equatable {
  final GeoFirePoint geoPoint;
  final String streetName;
  final List<FireHydrantArchiveModel> archives;

  const FireHydrantLogModel({
    required this.geoPoint,
    required this.streetName,
    required this.archives
  });

  factory FireHydrantLogModel.fromJson(Map<String, dynamic> json) {
    return FireHydrantLogModel(
      geoPoint: GeoFirePoint(json['position']['geopoint'].latitude, json['position']['geopoint'].longitude),
      streetName: json['streetName'],
      archives: List<FireHydrantArchiveModel>.from(json['archives'].map((archive) => FireHydrantArchiveModel.fromJson(archive)))
    );
  }

  static Map<String, dynamic> toJson(FireHydrantLogModel model) {
    return {
      'position': model.geoPoint.data,
      'streetName': model.streetName,
      'archives': model.archives.map((archive) => FireHydrantArchiveModel.toJson(archive)).toList()
    };
  }

  static FireHydrantLogModel emptyLog(GeoFirePoint geoPoint) {
    return FireHydrantLogModel(geoPoint: geoPoint, streetName: "", archives: const []);
  }

  static final FireHydrantLogModel mockData = FireHydrantLogModel(
    geoPoint: GeoFirePoint(48.88888737849572, 2.34311714079882),
    streetName: "aucune idee",
    archives: FireHydrantArchiveModel.mockData
  );

  static Set<Marker> getMarkers({required BuildContext context, required List<FireHydrantLogModel> logs}) {
    final Set<Marker> markers = logs.map((log) {
      print("${log.geoPoint.latitude} ${log.geoPoint.longitude}");
      return Marker(
        markerId: MarkerId(log.geoPoint.hash),
        position: LatLng(log.geoPoint.latitude, log.geoPoint.longitude),
        infoWindow: InfoWindow(title: log.streetName),
        onTap: () {
          //navigate to logs page
        }
      );
    }).toSet();
    return markers;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [geoPoint, streetName, archives];
}
