// lib/domain/entities/video_entity.dart

import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final String id;
  final String title;
  final String videoUrl;       // network URL or local file path
  final bool isLocalFile;      // true = local path, false = network URL
  final String username;
  final String caption;
  final String audioName;
  final String category;
  final int accentColor;       // stored as int (ARGB)
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;
  final DateTime createdAt;

  const VideoEntity({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.isLocalFile,
    required this.username,
    required this.caption,
    required this.audioName,
    required this.category,
    required this.accentColor,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.isLiked,
    required this.createdAt,
  });

  VideoEntity copyWith({
    String? id,
    String? title,
    String? videoUrl,
    bool? isLocalFile,
    String? username,
    String? caption,
    String? audioName,
    String? category,
    int? accentColor,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isLiked,
    DateTime? createdAt,
  }) {
    return VideoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      videoUrl: videoUrl ?? this.videoUrl,
      isLocalFile: isLocalFile ?? this.isLocalFile,
      username: username ?? this.username,
      caption: caption ?? this.caption,
      audioName: audioName ?? this.audioName,
      category: category ?? this.category,
      accentColor: accentColor ?? this.accentColor,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, videoUrl, isLiked, likesCount];
}
