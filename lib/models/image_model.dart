import 'package:fire_hydrant_mapper/constants/firebase_constants.dart';

class ImageModel {
  final String parentArchiveId;
  final String url;

  ImageModel({required this.parentArchiveId, required this.url});

  static Map<String, dynamic> toJson(ImageModel image) {
    return {
      FirebaseConstants.parentArchiveId: image.parentArchiveId,
      FirebaseConstants.url: image.url
    };
  }

  static ImageModel fromJson(Map<String, dynamic> json) {
    return ImageModel(
      parentArchiveId: json[FirebaseConstants.parentArchiveId],
      url: json[FirebaseConstants.url]
    );
  }
}