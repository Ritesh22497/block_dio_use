// lib/domain/entities/video_entity.dart

import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String username;
  final String userAvatar;
  final String caption;
  final String audioName;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;
  final DateTime createdAt;

  const VideoEntity({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.username,
    required this.userAvatar,
    required this.caption,
    required this.audioName,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.isLiked,
    required this.createdAt,
  });

  VideoEntity copyWith({
    String? id,
    String? videoUrl,
    String? thumbnailUrl,
    String? username,
    String? userAvatar,
    String? caption,
    String? audioName,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isLiked,
    DateTime? createdAt,
  }) {
    return VideoEntity(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      username: username ?? this.username,
      userAvatar: userAvatar ?? this.userAvatar,
      caption: caption ?? this.caption,
      audioName: audioName ?? this.audioName,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        videoUrl,
        thumbnailUrl,
        username,
        userAvatar,
        caption,
        audioName,
        likesCount,
        commentsCount,
        sharesCount,
        isLiked,
        createdAt,
      ];
}
