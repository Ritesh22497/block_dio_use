// // import 'dart:io';

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:uuid/uuid.dart';

// // class UploadVideoService {

// //   Future<void> uploadVideo(
// //     File videoFile,
// //     String caption,
// //   ) async {

// //     final id = const Uuid().v4();

// //     final ref = FirebaseStorage.instance
// //         .ref()
// //         .child("reels")
// //         .child("$id.mp4");

// //     await ref.putFile(videoFile);

// //     final videoUrl =
// //         await ref.getDownloadURL();

// //     await FirebaseFirestore.instance
// //         .collection("videos")
// //         .doc(id)
// //         .set({
// //       "id": id,
// //       "caption": caption,
// //       "videoUrl": videoUrl,
// //       "likesCount": 0,
// //       "commentsCount": 0,
// //       "sharesCount": 0,
// //       "isLiked": false,
// //       "createdAt":
// //           FieldValue.serverTimestamp(),
// //     });
// //   }
// // }
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:uuid/uuid.dart';

// class UploadVideoService {
//   final FirebaseFirestore firestore;

//   UploadVideoService(this.firestore);

//   Future<void> uploadVideo(
//     File file,
//     String caption,
//   ) async {
//     final id = const Uuid().v4();

//     final storageRef = FirebaseStorage.instance
//         .ref()
//         .child('videos')
//         .child('$id.mp4');

//     await storageRef.putFile(file);

//     final videoUrl =
//         await storageRef.getDownloadURL();

//     await firestore
//         .collection('videos')
//         .doc(id)
//         .set({
//       'id': id,
//       'caption': caption,
//       'videoUrl': videoUrl,
//       'likesCount': 0,
//       'commentsCount': 0,
//       'sharesCount': 0,
//       'isLiked': false,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   }
// }
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';


import 'package:http/http.dart' as http;

class UploadVideoService {
  final FirebaseFirestore firestore;

  UploadVideoService(this.firestore);

  Future<void> uploadVideo(
    File file,
    String caption,
  ) async {
    final id = const Uuid().v4();

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('videos')
        .child('$id.mp4');

    await storageRef.putFile(file);

    final videoUrl =
        await storageRef.getDownloadURL();

    await firestore
        .collection('videos')
        .doc(id)
        .set({
      'id': id,
      'caption': caption,
      'videoUrl': videoUrl,
      'likesCount': 0,
      'commentsCount': 0,
      'sharesCount': 0,
      'isLiked': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}


class CloudinaryService {

  static const String cloudName =
      "YOUR_CLOUD_NAME";

  static const String uploadPreset =
      "YOUR_UPLOAD_PRESET";

  Future<String?> uploadVideo(
      File videoFile) async {

    try {

      final uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/video/upload",
      );

      var request =
      http.MultipartRequest(
        "POST",
        uri,
      );

      request.fields["upload_preset"] =
          uploadPreset;

      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          videoFile.path,
        ),
      );

      final response =
      await request.send();

      final data =
      jsonDecode(
        await response.stream.bytesToString(),
      );

      return data["secure_url"];

    } catch (e) {
      print(e);
      return null;
    }
  }
}