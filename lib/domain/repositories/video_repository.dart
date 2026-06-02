// lib/domain/repositories/video_repository.dart

import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/video_entity.dart';

abstract class VideoRepository {
  /// Fetch paginated videos from Firestore
  Future<Either<Failure, List<VideoEntity>>> fetchVideos({
    int limit,
    String? lastDocumentId,
  });

  /// Toggle like on a video
  Future<Either<Failure, VideoEntity>> toggleLike({
    required String videoId,
    required bool isLiked,
  });

  /// Get a pre-cached video file path
  Future<Either<Failure, String>> getCachedVideoPath(String videoUrl);
}
