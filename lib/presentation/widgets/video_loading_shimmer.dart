// lib/presentation/widgets/video_loading_shimmer.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VideoLoadingShimmer extends StatelessWidget {
  final String thumbnailUrl;

  const VideoLoadingShimmer({super.key, required this.thumbnailUrl});

  @override
  Widget build(BuildContext context) {
    if (thumbnailUrl.isNotEmpty) {
      // Show thumbnail while video loads
      return Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: thumbnailUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => _Shimmer(),
            errorWidget: (_, __, ___) => _Shimmer(),
          ),
          // Subtle loading indicator on top
          const Positioned(
            bottom: 160,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white54),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return _Shimmer();
  }
}

class _Shimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade700,
      child: Container(color: Colors.grey.shade900),
    );
  }
}
