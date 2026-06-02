// lib/presentation/viewmodels/video_player_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/video_entity.dart';

class VideoPlayerViewModel extends ChangeNotifier {
  VideoPlayerController? _controller;
  VideoPlayerController? get controller => _controller;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  bool _hasError = false;
  bool get hasError => _hasError;

  bool _showControls = false;
  bool get showControls => _showControls;

  VideoEntity? _video;

  /// Initialize controller from cached path or URL
  Future<void> initialize({
    required VideoEntity video,
    String? cachedPath,
  }) async {
    if (_video?.id == video.id && _isInitialized) return;

    _video = video;
    _hasError = false;
    _isInitialized = false;
    notifyListeners();

    await _disposeController();

    try {
      _controller = cachedPath != null
          ? VideoPlayerController.file(
              await _fileFromPath(cachedPath),
            )
          : VideoPlayerController.networkUrl(
              Uri.parse(video.videoUrl),
            );

      await _controller!.initialize();
      _controller!.setLooping(true);
      _controller!.addListener(_onControllerUpdate);

      if (_isMuted) _controller!.setVolume(0);

      _isInitialized = true;
      notifyListeners();
    } catch (_) {
      _hasError = true;
      notifyListeners();
    }
  }

  void play() {
    if (!_isInitialized || _isPlaying) return;
    _controller?.play();
    _isPlaying = true;
    notifyListeners();
  }

  void pause() {
    if (!_isInitialized || !_isPlaying) return;
    _controller?.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void togglePlayPause() {
    _isPlaying ? pause() : play();
    _flashControls();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _controller?.setVolume(_isMuted ? 0 : 1);
    notifyListeners();
  }

  void _flashControls() {
    _showControls = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), () {
      _showControls = false;
      notifyListeners();
    });
  }

  void _onControllerUpdate() {
    final playing = _controller?.value.isPlaying ?? false;
    if (playing != _isPlaying) {
      _isPlaying = playing;
      notifyListeners();
    }
  }

  Future<void> _disposeController() async {
    _controller?.removeListener(_onControllerUpdate);
    await _controller?.dispose();
    _controller = null;
    _isInitialized = false;
    _isPlaying = false;
  }

  Future<dynamic> _fileFromPath(String path) async {
    return path.startsWith('/')
        ? _LocalFile(path)
        : throw Exception('Invalid path');
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }
}

// Thin wrapper to avoid dart:io import issues
class _LocalFile {
  final String path;
  _LocalFile(this.path);
}
