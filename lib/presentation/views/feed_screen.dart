// lib/presentation/views/feed_screen.dart

import 'package:block_dio_use/presentation/views/video_uploade/videoUpload.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/feed_viewmodel.dart';
import '../widgets/reel_item.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Full immersive mode for reels
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: _buildBody(vm),
           floatingActionButton: FloatingActionButton(
    backgroundColor: Colors.red,
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const UploadVideoScreen(),
        ),
      );
    },
    child: const Icon(Icons.add),
  ),

        );
      },
    );
  }

  Widget _buildBody(FeedViewModel vm) {
    switch (vm.state) {
      case FeedState.initial:
      case FeedState.loading:
        return const _LoadingPlaceholder();

      case FeedState.error:
        return _ErrorView(
          message: vm.errorMessage ?? 'Something went wrong',
          onRetry: vm.retry,
        );

      case FeedState.loaded:
      case FeedState.loadingMore:
        return _buildFeed(vm);
    }
  }

  Widget _buildFeed(FeedViewModel vm) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          itemCount: vm.videos.length + (vm.isLoadingMore ? 1 : 0),
          onPageChanged: vm.onPageChanged,
          itemBuilder: (context, index) {
            if (index == vm.videos.length) {
              return const _LoadMoreIndicator();
            }
            return ReelItem(
              key: ValueKey(vm.videos[index].id),
              video: vm.videos[index],
              isActive: index == vm.currentIndex,
            );
          },
        ),

        // Top bar overlay
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tab switcher (Following / For You)
                _TopTabBar(),

                // Search/camera icons
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt_outlined,
                          color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Supporting widgets
// ─────────────────────────────────────────────────────────────────────────────

class _TopTabBar extends StatefulWidget {
  @override
  State<_TopTabBar> createState() => _TopTabBarState();
}

class _TopTabBarState extends State<_TopTabBar> {
  int _selected = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Tab(label: 'Following', selected: _selected == 0,
            onTap: () => setState(() => _selected = 0)),
        const SizedBox(width: 16),
        _Tab(label: 'For You', selected: _selected == 1,
            onTap: () => setState(() => _selected = 1)),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white60,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 15,
              shadows: const [Shadow(blurRadius: 6, color: Colors.black87)],
            ),
          ),
          const SizedBox(height: 3),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: selected ? 40 : 0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
        strokeWidth: 2,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    debugPrint("error================:$message");
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.white70, size: 56),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Try Again',),
          ),
        ],
      ),
    );
  }
}

class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 2,
          ),
          SizedBox(height: 12),
          Text('Loading more...', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
