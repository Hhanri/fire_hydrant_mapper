import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_hydrant_mapper/constants/firebase_constants.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_archive_model.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_log_model.dart';
import 'package:fire_hydrant_mapper/services/location_service.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fire_hydrant_mapper/utils/extensions.dart';

class FirebaseService {
  final FirebaseFirestore fireInstance = FirebaseFirestore.instance;
  final Geoflutterfire geo = Geoflutterfire();

  Future<void> setLog({required FireHydrantLogModel logModel}) async {
    await fireInstance
      .collection(FirebaseConstants.logsCollection)
      .doc(logModel.geoPoint.hash)
      .set(FireHydrantLogModel.toJson(model: logModel));
  }

  Future<void> deleteLog({required String logId}) async {
    //delete log
    await fireInstance
        .collection(FirebaseConstants.logsCollection)
        .doc(logId)
        .delete();
    //delete archives previously from this log
    await fireInstance
      .collection(FirebaseConstants.archivesCollection)
      .where(FirebaseConstants.parentLogId, isEqualTo: logId)
      .get()
      .then((snapshot) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
  }

  Future<void> addLocalPoint() async {
    if (await LocationService.getLocationPermission()) {
      final Position position = await LocationService.getLocation();
      final GeoFirePoint geoPoint = position.geoFireFromPosition();
      await setLog(logModel: FireHydrantLogModel.emptyLog(geoFirePoint: geoPoint));
    } else {
      print("NO LOCATION PERMISSION");
    }
  }

  Future<void> setArchive(FireHydrantArchiveModel archive) async {
    await fireInstance
      .collection(FirebaseConstants.archivesCollection)
      .doc(archive.archiveId)
      .set(FireHydrantArchiveModel.toJson(archive));
  }

  Future<void> updateArchiveParentLogId({required String parentLogId, required String newParentLogId}) async {
    await fireInstance
      .collection(FirebaseConstants.archivesCollection)
      .where(FirebaseConstants.parentLogId, isEqualTo: parentLogId)
      .get()
      .then((snapshot) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
          doc.reference.update(
            {FirebaseConstants.parentLogId: newParentLogId}
          );
        }
      });
  }

  Future<void> updateLog({required FireHydrantLogModel oldLog, required FireHydrantLogModel newLog}) async {
    if (newLog != oldLog) {
      await setLog(logModel: newLog);
      if (newLog.logId != oldLog.logId) {
        await updateArchiveParentLogId(
          parentLogId: oldLog.logId, newParentLogId: newLog.logId
        );
      }
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLogsStream() {
    return fireInstance.collection(FirebaseConstants.logsCollection).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getArchivesStream({required String logId}) {
    return fireInstance
      .collection(FirebaseConstants.archivesCollection)
      .where(FirebaseConstants.parentLogId, isEqualTo: logId)
      .orderBy(FirebaseConstants.date)
      .snapshots();
  }
}