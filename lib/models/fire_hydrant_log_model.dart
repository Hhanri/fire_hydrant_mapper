import 'package:fire_hydrant_mapper/models/fire_hydrant_archive_model.dart';

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
}
