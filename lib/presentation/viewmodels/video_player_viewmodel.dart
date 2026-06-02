// lib/presentation/viewmodels/video_player_viewmodel.dart

import 'dart:io';
import 'package:block_dio_use/core/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/video_entity.dart';

enum PlayerState { idle, initializing, ready, error }

class VideoPlayerViewModel extends ChangeNotifier {
  VideoPlayerController? _controller;
  VideoPlayerController? get controller => _controller;

  PlayerState _state = PlayerState.idle;
  PlayerState get state => _state;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  String? _currentVideoId;

  bool get isReady => _state == PlayerState.ready && _controller != null;
  bool get hasError => _state == PlayerState.error;
Future<void> initialize(VideoEntity video) async {
  if (_currentVideoId == video.id && isReady) return;

  _currentVideoId = video.id;

  print("========== VIDEO ==========");
  print("ID : ${video.id}");
  print("URL : ${video.videoUrl}");
  print("LOCAL : ${video.isLocalFile}");

  _state = PlayerState.initializing;
  notifyListeners();

  await _disposeController();
print("ENTITY URL==================== => ${video.videoUrl}");
  try {
    if (video.isLocalFile) {
      print("ENTITY URL file==================== => ${video.videoUrl}");
      _controller = VideoPlayerController.file(
        File(video.videoUrl),
      );
    } else {
      print("ENTITY URL network==================== => ${video.videoUrl}");
      _controller = VideoPlayerController.networkUrl(
  Uri.parse(
    AppConstants.demoVideoUrl
    // video.videoUrl.isEmpty
    //     ? AppConstants.demoVideoUrl
    //     : video.videoUrl,
  ),
);
      // _controller = VideoPlayerController.networkUrl(
      //    Uri.parse(video.videoUrl.trim()),
      //  // Uri.parse( "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",),
      // );
    }

    await _controller!.initialize();

    print("VIDEO LOADED SUCCESS");

    _controller!.setLooping(true);
    _controller!.setVolume(_isMuted ? 0 : 1);
    _controller!.addListener(_onUpdate);

    _state = PlayerState.ready;
    notifyListeners();
  } catch (e, s) {
    print("VIDEO ERROR => $e");
    print(s);

    _state = PlayerState.error;
    notifyListeners();
  }
}
//   Future<void> initialize(VideoEntity video) async {
//     if (_currentVideoId == video.id && isReady) return;

//     _currentVideoId = video.id;
//     _state = PlayerState.initializing;
//     notifyListeners();

//     await _disposeController();

//     try {
//       if (video.isLocalFile) {
//         _controller = VideoPlayerController.file(File(video.videoUrl));
//       } else {
//         _controller = VideoPlayerController.networkUrl(
//           Uri.parse(video.videoUrl),
//         );
//       }

//       await _controller!.initialize();
//       _controller!.setLooping(true);
//       _controller!.setVolume(_isMuted ? 0 : 1);
//       _controller!.addListener(_onUpdate);

//       _state = PlayerState.ready;
//       notifyListeners();
//     } catch (e, stack) {
//   print("VIDEO INIT ERROR => $e");
//   print(stack);

//   _state = PlayerState.error;
//   notifyListeners();
// }
//   }

  void play() {
    if (!isReady || _isPlaying) return;
    _controller?.play();
    _isPlaying = true;
    notifyListeners();
  }

  void pause() {
    if (!isReady || !_isPlaying) return;
    _controller?.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void togglePlayPause() => _isPlaying ? pause() : play();

  void toggleMute() {
    _isMuted = !_isMuted;
    _controller?.setVolume(_isMuted ? 0 : 1);
    notifyListeners();
  }

  void _onUpdate() {
    final playing = _controller?.value.isPlaying ?? false;
    if (playing != _isPlaying) {
      _isPlaying = playing;
      notifyListeners();
    }
  }

  Future<void> _disposeController() async {
    _controller?.removeListener(_onUpdate);
    await _controller?.dispose();
    _controller = null;
    _isPlaying = false;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }
}
