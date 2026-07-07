import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class VideoFirestoreService {

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<void> saveVideo({
    required String videoUrl,
    required String caption,
  }) async {

    final id = const Uuid().v4();

    await firestore
        .collection("videos")
        .doc(id)
        .set({
      "id": id,
      "caption": caption,
      "videoUrl": videoUrl,
      "likesCount": 0,
      "commentsCount": 0,
      "sharesCount": 0,
      "isLiked": false,
      "createdAt":
      FieldValue.serverTimestamp(),
    });
  }
}