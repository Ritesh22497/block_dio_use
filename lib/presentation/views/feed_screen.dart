// lib/presentation/views/feed_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/feed_viewmodel.dart';
import '../widgets/add_video_sheet.dart';
import '../widgets/reel_item.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageCtrl;
  late AnimationController _fabCtrl;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    _fabCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _fabCtrl.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _openAddSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: const AddVideoSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedViewModel>(
      builder: (ctx, vm, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: _buildBody(ctx, vm),
          floatingActionButton: _buildFAB(ctx, vm),
        );
      },
    );
  }

  Widget _buildBody(BuildContext ctx, FeedViewModel vm) {
    switch (vm.state) {
      case FeedState.initial:
      case FeedState.loading:
        return const _FullScreenLoader();

      case FeedState.error:
        return _ErrorScreen(message: vm.errorMessage ?? 'Something went wrong', onRetry: vm.reload);

      case FeedState.loaded:
        if (vm.videos.isEmpty) return _EmptyScreen(onAdd: () => _openAddSheet(ctx));
        return _buildFeed(ctx, vm);
    }
  }

  Widget _buildFeed(BuildContext ctx, FeedViewModel vm) {
    final accent = vm.videos.isNotEmpty
        ? Color(vm.videos[vm.currentIndex.clamp(0, vm.videos.length - 1)].accentColor)
        : const Color(0xFF6C63FF);

    return Stack(
      children: [
        // Main PageView
        PageView.builder(
          controller: _pageCtrl,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          itemCount: vm.videos.length,
          onPageChanged: vm.onPageChanged,
          itemBuilder: (_, i) => ReelItem(
            key: ValueKey(vm.videos[i].id),
            video: vm.videos[i],
            isActive: i == vm.currentIndex,
          ),
        ),

        // Top bar
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo / App name
                _AppLogo(accent: accent),

                // Video count badge
                _VideoBadge(count: vm.videos.length, accent: accent),
              ],
            ),
          ),
        ),

        // Progress dots (right side vertical)
        if (vm.videos.length <= 20)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: _ProgressDots(
              total: vm.videos.length,
              current: vm.currentIndex,
              accent: accent,
            ),
          ),
      ],
    );
  }

  Widget _buildFAB(BuildContext ctx, FeedViewModel vm) {
    if (vm.state != FeedState.loaded) return const SizedBox.shrink();

    final accent = vm.videos.isNotEmpty && vm.currentIndex < vm.videos.length
        ? Color(vm.videos[vm.currentIndex].accentColor)
        : const Color(0xFF6C63FF);

    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: FloatingActionButton(
        onPressed: () => _openAddSheet(ctx),
        backgroundColor: accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _AppLogo extends StatelessWidget {
  final Color accent;
  const _AppLogo({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 8),
        const Text(
          'ReelBox',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _VideoBadge extends StatelessWidget {
  final int count;
  final Color accent;
  const _VideoBadge({required this.count, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.video_library_outlined, color: accent, size: 14),
          const SizedBox(width: 6),
          Text(
            '$count reels',
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  final int total;
  final int current;
  final Color accent;
  const _ProgressDots({required this.total, required this.current, required this.accent});

  @override
  Widget build(BuildContext context) {
    const maxVisible = 7;
    if (total <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(min(total, maxVisible), (i) {
          final isActive = i == current.clamp(0, maxVisible - 1);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(vertical: 2),
            width: isActive ? 5 : 3,
            height: isActive ? 16 : 6,
            decoration: BoxDecoration(
              color: isActive ? accent : Colors.white30,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}

class _FullScreenLoader extends StatefulWidget {
  const _FullScreenLoader();

  @override
  State<_FullScreenLoader> createState() => _FullScreenLoaderState();
}

class _FullScreenLoaderState extends State<_FullScreenLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, child) => Transform.rotate(
              angle: _ctrl.value * 2 * pi,
              child: child,
            ),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const SweepGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFFFF6584), Color(0xFF6C63FF)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Loading ReelBox...',
            style: TextStyle(color: Colors.white54, fontSize: 14, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorScreen({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 64),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 15)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyScreen extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyScreen({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎬', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 16),
          const Text('No reels yet!',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('Add your first reel to get started.',
              style: TextStyle(color: Colors.white54, fontSize: 15)),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Reel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}
