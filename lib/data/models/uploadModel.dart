import 'dart:io';

import 'package:block_dio_use/data/service/VideoFirestoreService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../data/service/uploadeService.dart';

class UploadVideoViewModel1 extends ChangeNotifier {
  final UploadVideoService service;

  UploadVideoViewModel1(this.service);

  bool loading = false;

  Future<void> uploadVideo(
    File file,
    String caption,
  ) async {
    try {
      final id = const Uuid().v4();

      debugPrint("File Path => ${file.path}");
      debugPrint("Exists => ${file.existsSync()}");

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('videos')
          .child('$id.mp4');

      final snapshot = await storageRef.putFile(file);

      debugPrint("Upload State => ${snapshot.state}");

      if (snapshot.state != TaskState.success) {
        throw Exception("Upload failed");
      }

      final downloadUrl =
          await snapshot.ref.getDownloadURL();

      debugPrint("Download URL => $downloadUrl");

      await FirebaseFirestore.instance
          .collection('videos')
          .doc(id)
          .set({
        'id': id,
        'caption': caption,
        'videoUrl': downloadUrl,
        'likesCount': 0,
        'commentsCount': 0,
        'sharesCount': 0,
        'isLiked': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint("Video Uploaded Successfully");
    } on FirebaseException catch (e) {
      debugPrint("Firebase Error Code => ${e.code}");
      debugPrint("Firebase Error => ${e.message}");
    } catch (e, s) {
      debugPrint("UPLOAD ERROR => $e");
      debugPrintStack(stackTrace: s);
    }
  }
}
class UploadVideoViewModel
    extends ChangeNotifier {

  final CloudinaryService cloudinary;
  final VideoFirestoreService firestore;

  UploadVideoViewModel({
    required this.cloudinary,
    required this.firestore,
  });

  bool loading = false;

  Future<void> uploadVideo(
      File file,
      String caption,
      ) async {

    loading = true;
    notifyListeners();

    try {

      final url =
      await cloudinary.uploadVideo(file);

      if (url == null) {
        throw Exception(
          "Upload Failed",
        );
      }

      await firestore.saveVideo(
        videoUrl: url,
        caption: caption,
      );

    } finally {
      loading = false;
      notifyListeners();
    }
  }
}