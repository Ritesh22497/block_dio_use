// lib/data/datasources/video_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../models/video_model.dart';

abstract class VideoRemoteDataSource {
  Future<List<VideoModel>> fetchVideos({int limit, String? lastDocumentId});
  Future<VideoModel> toggleLike({required String videoId, required bool isLiked});
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final FirebaseFirestore _firestore;

  VideoRemoteDataSourceImpl(this._firestore);

  @override
  Future<List<VideoModel>> fetchVideos({
    int limit = AppConstants.pageSize,
    String? lastDocumentId,
  }) async {
    Query query = _firestore
        .collection(AppConstants.videosCollection)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDocumentId != null) {
      final lastDoc = await _firestore
          .collection(AppConstants.videosCollection)
          .doc(lastDocumentId)
          .get();

      if (lastDoc.exists) {
        query = query.startAfterDocument(lastDoc);
      }
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => VideoModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<VideoModel> toggleLike({
    required String videoId,
    required bool isLiked,
  }) async {
    final ref = _firestore
        .collection(AppConstants.videosCollection)
        .doc(videoId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      if (!snapshot.exists) throw Exception('Video not found');

      final currentLikes = (snapshot.data()?['likesCount'] as num?)?.toInt() ?? 0;
      final newLikes = isLiked ? currentLikes + 1 : (currentLikes - 1).clamp(0, double.infinity).toInt();

      transaction.update(ref, {
        'likesCount': newLikes,
        'isLiked': isLiked,
      });
    });

    final updated = await ref.get();
    return VideoModel.fromFirestore(updated);
  }
}
