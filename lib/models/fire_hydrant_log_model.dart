import 'package:fire_hydrant_mapper/models/fire_hydrant_archive_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FireHydrantLogModel {
  final double latitude;
  final double longitude;
  final String streetName;
  final List<FireHydrantArchiveModel> archives;

  FireHydrantLogModel({
    required this.latitude,
    required this.longitude,
    required this.streetName,
    required this.archives
  });

  static final FireHydrantLogModel mockData = FireHydrantLogModel(
    latitude: 48.88888737849572,
    longitude: 2.34311714079882,
    streetName: "aucune idee",
    archives: FireHydrantArchiveModel.mockData
  );

  static Set<Marker> getMarkers({required BuildContext context, required List<FireHydrantLogModel> logs}) {
    final Set<Marker> markers = logs.map((log) {
      return Marker(
        markerId: MarkerId(LatLng(log.latitude, log.longitude).toString()),
        position: LatLng(log.latitude, log.longitude),
        infoWindow: InfoWindow(title: log.streetName),
        onTap: () {
          //navigate to logs page
        }
      );
    }).toSet();
    return markers;
  }
}
