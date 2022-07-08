import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fire_hydrant_mapper/constants/firebase_constants.dart';
import 'package:flutter/foundation.dart';

class FireHydrantArchiveModel extends Equatable {
  final String parentLogId;
  final String archiveId;
  final DateTime date;
  final double waterLevel;
  final String note;
  final List<String> images;

  const FireHydrantArchiveModel({
    required this.parentLogId,
    required this.archiveId,
    required this.date,
    required this.waterLevel,
    required this.note,
    required this.images
  });

  factory FireHydrantArchiveModel.fromJson(Map<String, dynamic> json) {
    return FireHydrantArchiveModel(
      archiveId: json[FirebaseConstants.archiveId],
      parentLogId: json[FirebaseConstants.parentLogId],
      date: (json[FirebaseConstants.date] as Timestamp).toDate(),
      waterLevel: json[FirebaseConstants.waterLevel],
      note: json[FirebaseConstants.note],
      images: List<String>.from(json[FirebaseConstants.images])
    );
  }

  static Map<String, dynamic> toJson(FireHydrantArchiveModel model) {
    return {
      FirebaseConstants.parentLogId: model.parentLogId,
      FirebaseConstants.date: model.date,
      FirebaseConstants.waterLevel: model.waterLevel,
      FirebaseConstants.note: model.note,
      FirebaseConstants.images: model.images
    };
  }

  static FireHydrantArchiveModel emptyArchive(String parentLogId) {
    return FireHydrantArchiveModel(
      archiveId: UniqueKey().toString(),
      parentLogId: parentLogId,
      date: DateTime.now(),
      waterLevel: 0,
      note: "",
      images: const []
    );
  }

  @override
  List<Object?> get props => [date, waterLevel, note, images];
}