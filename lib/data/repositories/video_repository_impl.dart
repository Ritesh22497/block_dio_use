// lib/data/repositories/video_repository_impl.dart

import '../../domain/entities/video_entity.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/local_database.dart';
import '../models/video_model.dart';

class VideoRepositoryImpl implements VideoRepository {
  final LocalDatabase _db;
  VideoRepositoryImpl(this._db);

  @override
  Future<List<VideoEntity>> getAllVideos() async {
    final models = await _db.getAll();
    return models;
  }

  @override
  Future<VideoEntity> insertVideo(VideoEntity video) async {
    final model = VideoModel.fromEntity(video);
    return await _db.insert(model);
  }

  @override
  Future<VideoEntity> updateVideo(VideoEntity video) async {
    final model = VideoModel.fromEntity(video);
    return await _db.update(model);
  }

  @override
  Future<void> deleteVideo(String id) => _db.delete(id);

  @override
  Future<bool> isDatabaseEmpty() async {
    final count = await _db.count();
    return count == 0;
  }
}
