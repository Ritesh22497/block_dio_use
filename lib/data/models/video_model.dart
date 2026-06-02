// lib/data/models/video_model.dart

import '../../domain/entities/video_entity.dart';

class VideoModel extends VideoEntity {
  const VideoModel({
    required super.id,
    required super.title,
    required super.videoUrl,
    required super.isLocalFile,
    required super.username,
    required super.caption,
    required super.audioName,
    required super.category,
    required super.accentColor,
    required super.likesCount,
    required super.commentsCount,
    required super.sharesCount,
    required super.isLiked,
    required super.createdAt,
  });

  factory VideoModel.fromMap(Map<String, dynamic> map) => VideoModel(
        id: map['id'] as String,
        title: map['title'] as String,
        videoUrl: map['video_url'] as String,
        isLocalFile: (map['is_local_file'] as int) == 1,
        username: map['username'] as String,
        caption: map['caption'] as String,
        audioName: map['audio_name'] as String,
        category: map['category'] as String,
        accentColor: map['accent_color'] as int,
        likesCount: map['likes_count'] as int,
        commentsCount: map['comments_count'] as int,
        sharesCount: map['shares_count'] as int,
        isLiked: (map['is_liked'] as int) == 1,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'video_url': videoUrl,
        'is_local_file': isLocalFile ? 1 : 0,
        'username': username,
        'caption': caption,
        'audio_name': audioName,
        'category': category,
        'accent_color': accentColor,
        'likes_count': likesCount,
        'comments_count': commentsCount,
        'shares_count': sharesCount,
        'is_liked': isLiked ? 1 : 0,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory VideoModel.fromEntity(VideoEntity e) => VideoModel(
        id: e.id,
        title: e.title,
        videoUrl: e.videoUrl,
        isLocalFile: e.isLocalFile,
        username: e.username,
        caption: e.caption,
        audioName: e.audioName,
        category: e.category,
        accentColor: e.accentColor,
        likesCount: e.likesCount,
        commentsCount: e.commentsCount,
        sharesCount: e.sharesCount,
        isLiked: e.isLiked,
        createdAt: e.createdAt,
      );
}
