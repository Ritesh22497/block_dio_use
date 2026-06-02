// lib/presentation/widgets/reel_action_buttons.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import '../../core/utils/extensions.dart';
import '../../domain/entities/video_entity.dart';

class ReelActionButtons extends StatelessWidget {
  final VideoEntity video;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onAudio;

  const ReelActionButtons({
    super.key,
    required this.video,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LikeButton(
          video: video,
          onLike: onLike,
        ),
        const SizedBox(height: 20),
        _ActionItem(
          icon: FontAwesomeIcons.comment,
          count: video.commentsCount,
          onTap: onComment,
        ),
        const SizedBox(height: 20),
        _ActionItem(
          icon: FontAwesomeIcons.share,
          count: video.sharesCount,
          onTap: onShare,
        ),
        const SizedBox(height: 20),
        _SpinningAudioDisc(
          avatarUrl: video.userAvatar,
          onTap: onAudio,
        ),
      ],
    );
  }
}

class _LikeButton extends StatelessWidget {
  final VideoEntity video;
  final VoidCallback onLike;

  const _LikeButton({required this.video, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LikeButton(
          size: 36,
          isLiked: video.isLiked,
          onTap: (isLiked) async {
            onLike();
            return !isLiked;
          },
          likeBuilder: (isLiked) => Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.white,
            size: 36,
          ),
          circleColor: const CircleColor(
            start: Colors.red,
            end: Colors.pink,
          ),
          bubblesColor: const BubblesColor(
            dotPrimaryColor: Colors.red,
            dotSecondaryColor: Colors.pinkAccent,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          video.likesCount.toCompactString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
          ),
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black26,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 4),
          Text(
            count.toCompactString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpinningAudioDisc extends StatefulWidget {
  final String avatarUrl;
  final VoidCallback onTap;

  const _SpinningAudioDisc({required this.avatarUrl, required this.onTap});

  @override
  State<_SpinningAudioDisc> createState() => _SpinningAudioDiscState();
}

class _SpinningAudioDiscState extends State<_SpinningAudioDisc>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: RotationTransition(
        turns: _controller,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            image: DecorationImage(
              image: widget.avatarUrl.isNotEmpty
                  ? NetworkImage(widget.avatarUrl)
                  : const AssetImage('assets/images/default_avatar.png')
                      as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
