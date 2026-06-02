// lib/presentation/widgets/reel_item.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/video_entity.dart';
import '../viewmodels/feed_viewmodel.dart';
import '../viewmodels/video_player_viewmodel.dart';
import 'reel_action_buttons.dart';
import 'reel_bottom_overlay.dart';
import 'video_loading_shimmer.dart';

class ReelItem extends StatefulWidget {
  final VideoEntity video;
  final bool isActive;

  const ReelItem({
    super.key,
    required this.video,
    required this.isActive,
  });

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem>
    with AutomaticKeepAliveClientMixin {
  late final VideoPlayerViewModel _playerVM;
  bool _showHeartAnimation = false;
  DateTime? _lastTapTime;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _playerVM = VideoPlayerViewModel();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final feedVM = context.read<FeedViewModel>();
    final cachedPath = feedVM.cachedPaths[widget.video.videoUrl];
    await _playerVM.initialize(
      video: widget.video,
      cachedPath: cachedPath,
    );
    if (widget.isActive && mounted) _playerVM.play();
  }

  @override
  void didUpdateWidget(ReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      widget.isActive ? _playerVM.play() : _playerVM.pause();
    }
    if (widget.video.videoUrl != oldWidget.video.videoUrl) {
      _initVideo();
    }
  }

  @override
  void dispose() {
    _playerVM.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!) < const Duration(milliseconds: 400)) {
      // Double tap — like!
      context.read<FeedViewModel>().toggleLike(widget.video.id);
      _triggerHeartAnimation();
    }
    _lastTapTime = now;
  }

  void _triggerHeartAnimation() {
    setState(() => _showHeartAnimation = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _showHeartAnimation = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<VideoPlayerViewModel>.value(
      value: _playerVM,
      child: Consumer<VideoPlayerViewModel>(
        builder: (context, playerVM, _) {
          return GestureDetector(
            onTap: _handleDoubleTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Video Layer ───────────────────────────────
                _VideoLayer(playerVM: playerVM, video: widget.video),

                // ── Gradient overlay ──────────────────────────
                const _GradientOverlay(),

                // ── Bottom info row ───────────────────────────
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ReelBottomOverlay(video: widget.video),
                ),

                // ── Right action buttons ──────────────────────
                Positioned(
                  right: 10,
                  bottom: 100,
                  child: Consumer<FeedViewModel>(
                    builder: (_, feedVM, __) => ReelActionButtons(
                      video: widget.video,
                      onLike: () => feedVM.toggleLike(widget.video.id),
                      onComment: () => _showComments(context),
                      onShare: () => Share.share(widget.video.videoUrl),
                      onAudio: () {},
                    ),
                  ),
                ),

                // ── Pause indicator ───────────────────────────
                if (playerVM.isInitialized && !playerVM.isPlaying)
                  const Center(
                    child: _PauseIndicator(),
                  ),

                // ── Heart animation on double tap ─────────────
                if (_showHeartAnimation)
                  const Center(child: _HeartBurstAnimation()),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _CommentsPlaceholder(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Video Layer
// ─────────────────────────────────────────────────────────────────────────────

class _VideoLayer extends StatelessWidget {
  final VideoPlayerViewModel playerVM;
  final VideoEntity video;

  const _VideoLayer({required this.playerVM, required this.video});

  @override
  Widget build(BuildContext context) {
    if (playerVM.hasError) {
      return _ErrorFallback(thumbnailUrl: video.thumbnailUrl);
    }
    if (!playerVM.isInitialized || playerVM.controller == null) {
      return VideoLoadingShimmer(thumbnailUrl: video.thumbnailUrl);
    }
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: playerVM.controller!.value.size.width,
          height: playerVM.controller!.value.size.height,
          child: VideoPlayer(playerVM.controller!),
        ),
      ),
    );
  }
}

class _ErrorFallback extends StatelessWidget {
  final String thumbnailUrl;
  const _ErrorFallback({required this.thumbnailUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (thumbnailUrl.isNotEmpty)
          Image.network(thumbnailUrl, fit: BoxFit.cover),
        Container(color: Colors.black54),
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.white70, size: 48),
              SizedBox(height: 8),
              Text(
                'Video unavailable',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Misc small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.4, 0.7, 1.0],
          colors: [
            Color(0x55000000),
            Colors.transparent,
            Colors.transparent,
            Color(0xCC000000),
          ],
        ),
      ),
    );
  }
}

class _PauseIndicator extends StatelessWidget {
  const _PauseIndicator();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 200),
      builder: (_, value, child) => Opacity(opacity: value, child: child),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black38,
        ),
        child: const Icon(Icons.pause, color: Colors.white, size: 48),
      ),
    );
  }
}

class _HeartBurstAnimation extends StatefulWidget {
  const _HeartBurstAnimation();

  @override
  State<_HeartBurstAnimation> createState() => _HeartBurstAnimationState();
}

class _HeartBurstAnimationState extends State<_HeartBurstAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scale = Tween<double>(begin: 0.3, end: 1.4).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(
          scale: _scale.value,
          child: const Icon(Icons.favorite, color: Colors.white, size: 100),
        ),
      ),
    );
  }
}

class _CommentsPlaceholder extends StatelessWidget {
  const _CommentsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Comments',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Comments coming soon',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
