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

  Future<void> addLog({required FireHydrantLogModel logModel}) async {
    return fireInstance.collection(FirebaseConstants.logsCollection).doc(logModel.geoPoint.hash).set(
      FireHydrantLogModel.toJson(model: logModel)
    );
  }

  Future<void> deleteLog({required String documentId}) async {
    //TODO: delete each doc in archives
    final currentLog = await fireInstance.collection(FirebaseConstants.logsCollection).doc(documentId).get();
    final archives = currentLog.data()![FirebaseConstants.archivesIds];
    for (String archive in archives) {
      fireInstance.collection(FirebaseConstants.archivesCollection).doc(archive).delete();
    }
    return fireInstance.collection(FirebaseConstants.logsCollection).doc(documentId).delete();
  }

  Future<void> addLocalPoint() async {
    if (await LocationService.getLocationPermission()) {
      final Position position = await LocationService.getLocation();
      final GeoFirePoint geoPoint = position.geoFireFromPosition();
      return addLog(logModel: FireHydrantLogModel.emptyLog(geoFirePoint: geoPoint));
    } else {
      print("NO LOCATION PERMISSION");
    }
  }

  Future<void> addArchive(FireHydrantArchiveModel archive) async {
    await fireInstance
      .collection(FirebaseConstants.archivesCollection)
      .add(FireHydrantArchiveModel.toJson(archive))
      .then((value) {
        //update Logs['archivesIds'] with the new archive Id
        final String archiveDocId = value.id;
        fireInstance
          .collection(FirebaseConstants.logsCollection)
          .doc(archive.parentLogId)
          .update({
            FirebaseConstants.archivesIds: FieldValue.arrayUnion([archiveDocId])
        });
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLogsStream() {
    return fireInstance.collection(FirebaseConstants.logsCollection).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getArchivesStream({required String documentId}) {
    return fireInstance
      .collection(FirebaseConstants.archivesCollection)
      .where(FirebaseConstants.parentLogId, isEqualTo: documentId)
      .orderBy(FirebaseConstants.date)
      .snapshots();
  }
}