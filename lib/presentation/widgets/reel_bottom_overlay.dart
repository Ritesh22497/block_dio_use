// lib/presentation/widgets/reel_bottom_overlay.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/entities/video_entity.dart';

class ReelBottomOverlay extends StatefulWidget {
  final VideoEntity video;

  const ReelBottomOverlay({super.key, required this.video});

  @override
  State<ReelBottomOverlay> createState() => _ReelBottomOverlayState();
}

class _ReelBottomOverlayState extends State<ReelBottomOverlay> {
  bool _isCaptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 80, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black87],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username row
          Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 10),
              Text(
                '@${widget.video.username}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                ),
              ),
              const SizedBox(width: 10),
              _FollowButton(),
            ],
          ),
          const SizedBox(height: 8),

          // Caption
          GestureDetector(
            onTap: () => setState(() => _isCaptionExpanded = !_isCaptionExpanded),
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _isCaptionExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Text(
                widget.video.caption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: _captionStyle,
              ),
              secondChild: Text(
                widget.video.caption,
                style: _captionStyle,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Audio strip
          _AudioStrip(audioName: widget.video.audioName),
        ],
      ),
    );
  }

  TextStyle get _captionStyle => const TextStyle(
        color: Colors.white,
        fontSize: 14,
        height: 1.4,
        shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
      );

  Widget _buildAvatar() => CircleAvatar(
        radius: 18,
        backgroundImage: widget.video.userAvatar.isNotEmpty
            ? NetworkImage(widget.video.userAvatar)
            : null,
        backgroundColor: Colors.grey.shade800,
        child: widget.video.userAvatar.isEmpty
            ? const Icon(Icons.person, color: Colors.white, size: 18)
            : null,
      );
}

class _FollowButton extends StatefulWidget {
  @override
  State<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<_FollowButton> {
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isFollowing = !_isFollowing),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: _isFollowing ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white, width: 1.2),
        ),
        child: Text(
          _isFollowing ? 'Following' : 'Follow',
          style: TextStyle(
            color: _isFollowing ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _AudioStrip extends StatelessWidget {
  final String audioName;

  const _AudioStrip({required this.audioName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(FontAwesomeIcons.music, color: Colors.white, size: 14),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            audioName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
