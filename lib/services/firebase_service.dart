import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_log_model.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

class FirebaseService {
  final FirebaseFirestore fireInstance = FirebaseFirestore.instance;
  final Geoflutterfire geo = Geoflutterfire();

  final String logsDocument = "logs";

  Future<void> addGeoPoint({required FireHydrantLogModel logModel}) async {
    return fireInstance.collection(logsDocument).add(
      {}
    ).then((value) => fireInstance.collection(logsDocument).doc(value.id).set(
      FireHydrantLogModel.toJson(id: value.id, model: logModel)
    ));

  }
  Future<void> addLocalPoint() async {
    await Geolocator.requestPermission();
    final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final GeoFirePoint geoPoint = GeoFirePoint(position.latitude, position.longitude);
    return addGeoPoint(logModel: FireHydrantLogModel.emptyLog(geoPoint: geoPoint));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLogsStream() {
    return fireInstance.collection('logs').snapshots();
  }
}