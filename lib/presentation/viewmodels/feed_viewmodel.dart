// lib/presentation/viewmodels/feed_viewmodel.dart

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/demo_seeder.dart';
import '../../domain/entities/video_entity.dart';
import '../../domain/usecases/video_usecases.dart';

enum FeedState { initial, loading, loaded, error }

class FeedViewModel extends ChangeNotifier {
  final GetAllVideosUseCase getAllVideos;
  final InsertVideoUseCase insertVideo;
  final UpdateVideoUseCase updateVideo;
  final DeleteVideoUseCase deleteVideo;
  final DemoSeeder seeder;

  FeedViewModel({
    required this.getAllVideos,
    required this.insertVideo,
    required this.updateVideo,
    required this.deleteVideo,
    required this.seeder,
  }) {
    _init();
  }

  // ── State ──────────────────────────────────────────────
  FeedState _state = FeedState.initial;
  FeedState get state => _state;

  List<VideoEntity> _videos = [];
  List<VideoEntity> get videos => List.unmodifiable(_videos);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool _isAddingVideo = false;
  bool get isAddingVideo => _isAddingVideo;

  String? _addVideoError;
  String? get addVideoError => _addVideoError;

  final _uuid = const Uuid();

  // ── Init ───────────────────────────────────────────────
  Future<void> _init() async {
    _setState(FeedState.loading);
    try {
      // Seed demo data on first launch
      await seeder.seedIfEmpty();
      final list = await getAllVideos();
      _videos = list;
      _setState(FeedState.loaded);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(FeedState.error);
    }
  }

  Future<void> reload() => _init();

  // ── Navigation ─────────────────────────────────────────
  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // ── Like (optimistic) ──────────────────────────────────
  Future<void> toggleLike(String videoId) async {
    final idx = _videos.indexWhere((v) => v.id == videoId);
    if (idx == -1) return;

    final v = _videos[idx];
    final updated = v.copyWith(
      isLiked: !v.isLiked,
      likesCount: v.isLiked ? v.likesCount - 1 : v.likesCount + 1,
    );

    _videos[idx] = updated;
    notifyListeners();

    try {
      await updateVideo(updated);
    } catch (_) {
      // Revert
      _videos[idx] = v;
      notifyListeners();
    }
  }

  // ── Add Video ──────────────────────────────────────────

  /// Add from a network URL (for demo/manual URL entry)
  Future<bool> addVideoFromUrl({
    required String url,
    required String title,
    required String username,
    required String caption,
    required String category,
    required int accentColor,
  }) async {
    _isAddingVideo = true;
    _addVideoError = null;
    notifyListeners();

    try {
      final entity = VideoEntity(
        id: _uuid.v4(),
        title: title.isEmpty ? 'My Reel' : title,
        videoUrl: url,
        isLocalFile: false,
        username: username.isEmpty ? 'me' : username,
        caption: caption.isEmpty ? '🎬 New reel!' : caption,
        audioName: 'Original Sound',
        category: category,
        accentColor: accentColor,
        likesCount: 0,
        commentsCount: 0,
        sharesCount: 0,
        isLiked: false,
        createdAt: DateTime.now(),
      );
      final saved = await insertVideo(entity);
      _videos.insert(0, saved);
      _isAddingVideo = false;
      notifyListeners();
      return true;
    } catch (e) {
      _addVideoError = 'Failed to add video: $e';
      _isAddingVideo = false;
      notifyListeners();
      return false;
    }
  }

  /// Add from local file picker
  Future<bool> addVideoFromFilePicker({
    required String title,
    required String username,
    required String caption,
    required String category,
    required int accentColor,
  }) async {
    _isAddingVideo = true;
    _addVideoError = null;
    notifyListeners();

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        _isAddingVideo = false;
        notifyListeners();
        return false;
      }

      final path = result.files.single.path;
      if (path == null) {
        _addVideoError = 'Could not get file path';
        _isAddingVideo = false;
        notifyListeners();
        return false;
      }

      final file = File(path);
      if (!await file.exists()) {
        _addVideoError = 'File does not exist';
        _isAddingVideo = false;
        notifyListeners();
        return false;
      }

      final entity = VideoEntity(
        id: _uuid.v4(),
        title: title.isEmpty ? result.files.single.name : title,
        videoUrl: path,
        isLocalFile: true,
        username: username.isEmpty ? 'me' : username,
        caption: caption.isEmpty ? '🎬 My reel!' : caption,
        audioName: 'Original Sound',
        category: category,
        accentColor: accentColor,
        likesCount: 0,
        commentsCount: 0,
        sharesCount: 0,
        isLiked: false,
        createdAt: DateTime.now(),
      );

      final saved = await insertVideo(entity);
      _videos.insert(0, saved);
      _isAddingVideo = false;
      notifyListeners();
      return true;
    } catch (e) {
      _addVideoError = 'Failed to add video: $e';
      _isAddingVideo = false;
      notifyListeners();
      return false;
    }
  }

  // ── Delete ─────────────────────────────────────────────
  Future<void> deleteVideoById(String id) async {
    final idx = _videos.indexWhere((v) => v.id == id);
    if (idx == -1) return;

    final removed = _videos[idx];
    _videos.removeAt(idx);

    // Fix current index after deletion
    if (_currentIndex >= _videos.length && _currentIndex > 0) {
      _currentIndex = _videos.length - 1;
    }
    notifyListeners();

    try {
      await deleteVideo(id);
    } catch (_) {
      // Revert
      _videos.insert(idx, removed);
      notifyListeners();
    }
  }

  void _setState(FeedState s) {
    _state = s;
    notifyListeners();
  }
}
