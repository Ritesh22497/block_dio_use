// lib/data/models/video_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/video_entity.dart';

class VideoModel extends VideoEntity {
  const VideoModel({
    required super.id,
    required super.videoUrl,
    required super.thumbnailUrl,
    required super.username,
    required super.userAvatar,
    required super.caption,
    required super.audioName,
    required super.likesCount,
    required super.commentsCount,
    required super.sharesCount,
    required super.isLiked,
    required super.createdAt,
  });

  factory VideoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VideoModel(
      id: doc.id,
      videoUrl: data['videoUrl'] as String? ?? '',
      thumbnailUrl: data['thumbnailUrl'] as String? ?? '',
      username: data['username'] as String? ?? 'unknown',
      userAvatar: data['userAvatar'] as String? ?? '',
      caption: data['caption'] as String? ?? '',
      audioName: data['audioName'] as String? ?? 'Original Sound',
      likesCount: (data['likesCount'] as num?)?.toInt() ?? 0,
      commentsCount: (data['commentsCount'] as num?)?.toInt() ?? 0,
      sharesCount: (data['sharesCount'] as num?)?.toInt() ?? 0,
      isLiked: data['isLiked'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,
        'username': username,
        'userAvatar': userAvatar,
        'caption': caption,
        'audioName': audioName,
        'likesCount': likesCount,
        'commentsCount': commentsCount,
        'sharesCount': sharesCount,
        'isLiked': isLiked,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory VideoModel.fromEntity(VideoEntity entity) => VideoModel(
        id: entity.id,
        videoUrl: entity.videoUrl,
        thumbnailUrl: entity.thumbnailUrl,
        username: entity.username,
        userAvatar: entity.userAvatar,
        caption: entity.caption,
        audioName: entity.audioName,
        likesCount: entity.likesCount,
        commentsCount: entity.commentsCount,
        sharesCount: entity.sharesCount,
        isLiked: entity.isLiked,
        createdAt: entity.createdAt,
      );
}
