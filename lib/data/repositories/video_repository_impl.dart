// lib/data/repositories/video_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/video_entity.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/video_cache_service.dart';
import '../datasources/video_remote_datasource.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource _remoteDataSource;

  VideoRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<VideoEntity>>> fetchVideos({
    int limit = 10,
    String? lastDocumentId,
  }) async {
    try {
      final videos = await _remoteDataSource.fetchVideos(
        limit: limit,
        lastDocumentId: lastDocumentId,
      );
      return Right(videos);
    } 
    // on FirebaseException catch (e) {
    //   return Left(FirestoreFailure(e.message ?? 'Firestore error'));
    // }
     catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VideoEntity>> toggleLike({
    required String videoId,
    required bool isLiked,
  }) async {
    try {
      final updated = await _remoteDataSource.toggleLike(
        videoId: videoId,
        isLiked: isLiked,
      );
      return Right(updated);
    } 
    // on FirebaseException catch (e) {
    //   return Left(FirestoreFailure(e.message ?? 'Like toggle failed'));
    // }
     catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getCachedVideoPath(String videoUrl) async {
    try {
      final path = await VideoCacheManager.getCachedPath(videoUrl);
      return Right(path);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
