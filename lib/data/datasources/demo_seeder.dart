// lib/data/datasources/demo_seeder.dart

import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/video_entity.dart';
import '../../domain/repositories/video_repository.dart';

class DemoSeeder {
  final VideoRepository _repository;
  final _uuid = const Uuid();

  DemoSeeder(this._repository);

  Future<void> seedIfEmpty() async {
    final isEmpty = await _repository.isDatabaseEmpty();
    if (!isEmpty) return;

    final now = DateTime.now();

    for (int i = 0; i < AppConstants.demoVideos.length; i++) {
      final data = AppConstants.demoVideos[i];
      final randomLikes = 1000 + (i * 7919 % 98000);
      final video = VideoEntity(
        id: _uuid.v4(),
        title: data['title']!,
        videoUrl: data['url']!,
        isLocalFile: false,
        username: data['username']!,
        caption: data['caption']!,
        audioName: data['audio']!,
        category: data['category']!,
        accentColor: int.parse(data['color']!),
        likesCount: randomLikes,
        commentsCount: randomLikes ~/ 10,
        sharesCount: randomLikes ~/ 25,
        isLiked: false,
        createdAt: now.subtract(Duration(hours: i * 3)),
      );
      await _repository.insertVideo(video);
    }
  }
}
