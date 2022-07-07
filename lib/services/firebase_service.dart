import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_hydrant_mapper/constants/firebase_constants.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_log_model.dart';
import 'package:fire_hydrant_mapper/services/location_service.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fire_hydrant_mapper/utils/extensions.dart';

class FirebaseService {
  final FirebaseFirestore fireInstance = FirebaseFirestore.instance;
  final Geoflutterfire geo = Geoflutterfire();

  final String logsDocument = "logs";

  Future<void> addGeoPoint({required FireHydrantLogModel logModel}) async {
    return fireInstance.collection(logsDocument).doc(logModel.geoPoint.hash).set(
      FireHydrantLogModel.toJson(model: logModel)
    );
  }

  Future<void> deleteGeoPoint({required String documentId}) async {
    //TODO: delete each doc in archives
    final currentLog = await fireInstance.collection(logsDocument).doc(documentId).get();
    final archives = currentLog.data()![FirebaseConstants.archivesIds];
    for (String archive in archives) {
      fireInstance.collection('archives').doc(archive).delete();
    }
    return fireInstance.collection(logsDocument).doc(documentId).delete();
  }

  Future<void> addLocalPoint() async {
    if (await LocationService.getLocationPermission()) {
      final Position position = await LocationService.getLocation();
      final GeoFirePoint geoPoint = position.geoFireFromPosition();
      return addGeoPoint(logModel: FireHydrantLogModel.emptyLog(geoFirePoint: geoPoint));
    } else {
      print("NO LOCATION PERMISSION");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLogsStream() {
    return fireInstance.collection('logs').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getArchivesStream({required String documentId}) {
    return fireInstance
      .collection(FirebaseConstants.archivesCollection)
      .where(FirebaseConstants.parentLogId, isEqualTo: documentId)
      .orderBy(FirebaseConstants.date)
      .snapshots();
  }
}