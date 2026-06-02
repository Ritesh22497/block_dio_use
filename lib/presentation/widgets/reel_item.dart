// lib/presentation/widgets/reel_item.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../core/utils/extensions.dart';
import '../../domain/entities/video_entity.dart';
import '../viewmodels/feed_viewmodel.dart';
import '../viewmodels/video_player_viewmodel.dart';

class ReelItem extends StatefulWidget {
  final VideoEntity video;
  final bool isActive;

  const ReelItem({super.key, required this.video, required this.isActive});

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late final VideoPlayerViewModel _playerVM;
  late AnimationController _heartCtrl;
  late AnimationController _tapRippleCtrl;
  bool _showHeart = false;
  Offset _tapPosition = Offset.zero;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _playerVM = VideoPlayerViewModel();
    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _tapRippleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _initVideo();
  }

  Future<void> _initVideo() async {
    await _playerVM.initialize(widget.video);
    if (widget.isActive && mounted) _playerVM.play();
  }

  @override
  void didUpdateWidget(ReelItem old) {
    super.didUpdateWidget(old);
    if (widget.isActive != old.isActive) {
      widget.isActive ? _playerVM.play() : _playerVM.pause();
    }
    if (widget.video.videoUrl != old.video.videoUrl) {
      _initVideo();
    }
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    _tapRippleCtrl.dispose();
    _playerVM.dispose();
    super.dispose();
  }

  void _onDoubleTap(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
      _showHeart = true;
    });
    _heartCtrl.forward(from: 0).then((_) {
      if (mounted) setState(() => _showHeart = false);
    });
    context.read<FeedViewModel>().toggleLike(widget.video.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: _playerVM,
      child: Consumer<VideoPlayerViewModel>(
        builder: (ctx, vm, _) {
          final accent = Color(widget.video.accentColor);
          return GestureDetector(
            onDoubleTapDown: _onDoubleTap,
            onDoubleTap: () {},
            onTap: vm.togglePlayPause,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Background color (shows before video loads) ──
                Container(color: accent.withOpacity(0.15)),

                // ── Video ────────────────────────────────────────
                _VideoLayer(vm: vm, accent: accent),

                // ── Gradient overlay (bottom heavy) ──────────────
                _buildGradient(accent),

                // ── Category chip (top left) ─────────────────────
                Positioned(
                  top: 60,
                  left: 16,
                  child: _CategoryChip(
                    label: widget.video.category,
                    color: accent,
                  ),
                ),

                // ── Right action bar ─────────────────────────────
                Positioned(
                  right: 12,
                  bottom: 110,
                  child: _ActionBar(video: widget.video, accent: accent),
                ),

                // ── Bottom info ──────────────────────────────────
                Positioned(
                  left: 0,
                  right: 72,
                  bottom: 0,
                  child: _BottomInfo(video: widget.video, accent: accent),
                ),

                // ── Pause indicator ──────────────────────────────
                if (vm.isReady && !vm.isPlaying)
                  Center(child: _PauseIndicator(accent: accent)),

                // ── Double-tap heart ─────────────────────────────
                if (_showHeart)
                  Positioned(
                    left: _tapPosition.dx - 50,
                    top: _tapPosition.dy - 50,
                    child: _HeartBurst(ctrl: _heartCtrl),
                  ),

                // ── Mute indicator ───────────────────────────────
                Positioned(
                  top: 60,
                  right: 16,
                  child: GestureDetector(
                    onTap: vm.toggleMute,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Icon(
                        vm.isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGradient(Color accent) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.35, 0.65, 1.0],
          colors: [
            Colors.black54,
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.85),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _VideoLayer extends StatelessWidget {
  final VideoPlayerViewModel vm;
  final Color accent;
  const _VideoLayer({required this.vm, required this.accent});

  @override
  Widget build(BuildContext context) {
    if (vm.hasError) {
      return _ErrorPlaceholder(accent: accent);
    }
    if (!vm.isReady || vm.controller == null) {
      return _LoadingPlaceholder(accent: accent);
    }
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: vm.controller!.value.size.width,
          height: vm.controller!.value.size.height,
          child: VideoPlayer(vm.controller!),
        ),
      ),
    );
  }
}

class _LoadingPlaceholder extends StatefulWidget {
  final Color accent;
  const _LoadingPlaceholder({required this.accent});

  @override
  State<_LoadingPlaceholder> createState() => _LoadingPlaceholderState();
}

class _LoadingPlaceholderState extends State<_LoadingPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        color: widget.accent.withOpacity(_anim.value * 0.15),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(widget.accent),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Loading video...',
                style: TextStyle(color: widget.accent.withOpacity(0.8), fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  final Color accent;
  const _ErrorPlaceholder({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image_outlined, color: accent, size: 56),
            const SizedBox(height: 12),
            const Text('Video unavailable',
                style: TextStyle(color: Colors.white60, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Info ───────────────────────────────────────────────────────────────

class _BottomInfo extends StatefulWidget {
  final VideoEntity video;
  final Color accent;
  const _BottomInfo({required this.video, required this.accent});

  @override
  State<_BottomInfo> createState() => _BottomInfoState();
}

class _BottomInfoState extends State<_BottomInfo> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Username row
          Row(
            children: [
              _AvatarCircle(
                username: widget.video.username,
                accent: widget.accent,
              ),
              const SizedBox(width: 10),
              Text(
                '@${widget.video.username}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            widget.video.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),

          // Caption (expandable)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              widget.video.caption,
              maxLines: _expanded ? null : 2,
              overflow: _expanded ? null : TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Audio strip
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: widget.accent.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: widget.accent.withOpacity(0.6), width: 1),
                ),
                child: const Icon(Icons.music_note, color: Colors.white, size: 12),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.video.audioName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Avatar Circle ─────────────────────────────────────────────────────────────

class _AvatarCircle extends StatelessWidget {
  final String username;
  final Color accent;
  const _AvatarCircle({required this.username, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [accent, accent.withOpacity(0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Center(
        child: Text(
          username.initials,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// ── Category Chip ─────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final String label;
  final Color color;
  const _CategoryChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.7), width: 1),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8)],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Right Action Bar ──────────────────────────────────────────────────────────

class _ActionBar extends StatelessWidget {
  final VideoEntity video;
  final Color accent;
  const _ActionBar({required this.video, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedViewModel>(
      builder: (ctx, vm, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Like
          _ActionBtn(
            icon: video.isLiked ? Icons.favorite : Icons.favorite_border,
            label: video.likesCount.toCompact(),
            color: video.isLiked ? Colors.red : Colors.white,
            accent: accent,
            onTap: () => vm.toggleLike(video.id),
          ),
          const SizedBox(height: 20),

          // Comments
          _ActionBtn(
            icon: Icons.chat_bubble_outline,
            label: video.commentsCount.toCompact(),
            color: Colors.white,
            accent: accent,
            onTap: () => _showComments(ctx),
          ),
          const SizedBox(height: 20),

          // Share
          _ActionBtn(
            icon: Icons.reply_outlined,
            label: video.sharesCount.toCompact(),
            color: Colors.white,
            accent: accent,
            onTap: () {},
          ),
          const SizedBox(height: 20),

          // Delete
          _ActionBtn(
            icon: Icons.delete_outline,
            label: '',
            color: Colors.white70,
            accent: Colors.red.shade300,
            onTap: () => _confirmDelete(ctx, vm),
          ),

          const SizedBox(height: 20),
          // Spinning disc
          _SpinDisc(accent: accent),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, FeedViewModel vm) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.delete_forever, color: Colors.redAccent, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Delete this reel?',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone.',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      vm.deleteVideoById(video.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showComments(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chat_bubble_outline, color: accent, size: 48),
              const SizedBox(height: 12),
              const Text('Comments', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('No comments yet. Be the first! 💬',
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color accent;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black38,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white12, width: 0.5),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ]
        ],
      ),
    );
  }
}

// ── Spinning Audio Disc ───────────────────────────────────────────────────────

class _SpinDisc extends StatefulWidget {
  final Color accent;
  const _SpinDisc({required this.accent});

  @override
  State<_SpinDisc> createState() => _SpinDiscState();
}

class _SpinDiscState extends State<_SpinDisc> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _ctrl,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [widget.accent.withOpacity(0.4), Colors.black87],
          ),
          border: Border.all(color: widget.accent, width: 2),
        ),
        child: Center(
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: widget.accent, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Pause Indicator ───────────────────────────────────────────────────────────

class _PauseIndicator extends StatelessWidget {
  final Color accent;
  const _PauseIndicator({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black45,
        border: Border.all(color: accent.withOpacity(0.5), width: 1.5),
      ),
      child: const Icon(Icons.pause, color: Colors.white, size: 44),
    );
  }
}

// ── Heart Burst ───────────────────────────────────────────────────────────────

class _HeartBurst extends StatelessWidget {
  final AnimationController ctrl;
  const _HeartBurst({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final scale = Tween<double>(begin: 0.2, end: 1.3)
        .animate(CurvedAnimation(parent: ctrl, curve: Curves.elasticOut));
    final opacity = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: ctrl, curve: const Interval(0.5, 1.0, curve: Curves.easeOut)));

    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) => Opacity(
        opacity: opacity.value,
        child: Transform.scale(
          scale: scale.value,
          child: const Icon(Icons.favorite, color: Colors.white, size: 100),
        ),
      ),
    );
  }
}
