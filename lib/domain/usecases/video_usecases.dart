// lib/domain/usecases/fetch_videos_usecase.dart

import '../entities/video_entity.dart';
import '../repositories/video_repository.dart';

class FetchVideosUseCase {
  final VideoRepository _repository;

  FetchVideosUseCase(this._repository);

  Future<Either<Failure, List<VideoEntity>>> call({
    int limit = AppConstants.pageSize,
    String? lastDocumentId,
  }) {
    return _repository.fetchVideos(
      limit: limit,
      lastDocumentId: lastDocumentId,
    );
  }
}

// lib/domain/usecases/toggle_like_usecase.dart
class ToggleLikeUseCase {
  final VideoRepository _repository;

  ToggleLikeUseCase(this._repository);

  Future<Either<Failure, VideoEntity>> call({
    required String videoId,
    required bool isLiked,
  }) {
    return _repository.toggleLike(videoId: videoId, isLiked: isLiked);
  }
}

// lib/domain/usecases/get_cached_video_usecase.dart
class GetCachedVideoUseCase {
  final VideoRepository _repository;

  GetCachedVideoUseCase(this._repository);

  Future<Either<Failure, String>> call(String videoUrl) {
    return _repository.getCachedVideoPath(videoUrl);
  }
}
