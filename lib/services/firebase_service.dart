import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_log_model.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

class FirebaseService {
  final FirebaseFirestore fireInstance = FirebaseFirestore.instance;
  final Geoflutterfire geo = Geoflutterfire();

  final String logsDocument = "logs";

  Future<DocumentReference> addGeoPoint({required FireHydrantLogModel logModel}) async {
    return fireInstance.collection(logsDocument).add(
      FireHydrantLogModel.toJson(logModel)
    );

  }
  Future<DocumentReference> addLocalPoint() async {
    await Geolocator.requestPermission();
    final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final GeoFirePoint geoPoint = GeoFirePoint(position.latitude, position.longitude);
    return addGeoPoint(logModel: FireHydrantLogModel.emptyLog(geoPoint));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLogsStream() {
    return fireInstance.collection('logs').snapshots();
  }
}