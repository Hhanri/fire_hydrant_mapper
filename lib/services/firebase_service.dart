import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_log_model.dart';
import 'package:fire_hydrant_mapper/services/location_service.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

class FirebaseService {
  final FirebaseFirestore fireInstance = FirebaseFirestore.instance;
  final Geoflutterfire geo = Geoflutterfire();

  final String logsDocument = "logs";

  Future<void> addGeoPoint({required FireHydrantLogModel logModel}) async {
    return fireInstance.collection(logsDocument).doc(logModel.geoPoint.hash).set(
      FireHydrantLogModel.toJson(model: logModel)
    );
    return fireInstance.collection(logsDocument).add(
      {}
    ).then((value) => fireInstance.collection(logsDocument).doc(value.id).set(
      FireHydrantLogModel.toJson(model: logModel)
    ));
  }

  Future<void> addLocalPoint() async {
    if (await LocationService.getLocationPermission()) {
      final Position position = await LocationService.getLocation();
      final GeoFirePoint geoPoint = GeoFirePoint(position.latitude, position.longitude);
      return addGeoPoint(logModel: FireHydrantLogModel.emptyLog(geoPoint: geoPoint));
    } else {
      print("NO LOCATION PERMISSION");
    }

  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLogsStream() {
    return fireInstance.collection('logs').snapshots();
  }
}