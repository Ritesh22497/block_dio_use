// lib/domain/repositories/video_repository.dart

import '../entities/video_entity.dart';

abstract class VideoRepository {
  Future<List<VideoEntity>> getAllVideos();
  Future<VideoEntity> insertVideo(VideoEntity video);
  Future<VideoEntity> updateVideo(VideoEntity video);
  Future<void> deleteVideo(String id);
  Future<bool> isDatabaseEmpty();
}
