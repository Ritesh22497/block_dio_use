// lib/domain/usecases/video_usecases.dart

import '../entities/video_entity.dart';
import '../repositories/video_repository.dart';

class GetAllVideosUseCase {
  final VideoRepository _repo;
  GetAllVideosUseCase(this._repo);
  Future<List<VideoEntity>> call() => _repo.getAllVideos();
}

class InsertVideoUseCase {
  final VideoRepository _repo;
  InsertVideoUseCase(this._repo);
  Future<VideoEntity> call(VideoEntity video) => _repo.insertVideo(video);
}

class UpdateVideoUseCase {
  final VideoRepository _repo;
  UpdateVideoUseCase(this._repo);
  Future<VideoEntity> call(VideoEntity video) => _repo.updateVideo(video);
}

class DeleteVideoUseCase {
  final VideoRepository _repo;
  DeleteVideoUseCase(this._repo);
  Future<void> call(String id) => _repo.deleteVideo(id);
}

class IsDatabaseEmptyUseCase {
  final VideoRepository _repo;
  IsDatabaseEmptyUseCase(this._repo);
  Future<bool> call() => _repo.isDatabaseEmpty();
}
