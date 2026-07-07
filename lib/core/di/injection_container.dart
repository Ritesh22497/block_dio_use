// lib/core/di/injection_container.dart

import 'package:block_dio_use/data/models/uploadModel.dart';
import 'package:block_dio_use/data/service/VideoFirestoreService.dart';
import 'package:block_dio_use/data/service/uploadeService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import '../../data/datasources/video_remote_datasource.dart';
import '../../data/repositories/video_repository_impl.dart';
import '../../domain/repositories/video_repository.dart';
import '../../domain/usecases/video_usecases.dart';
import '../../presentation/viewmodels/feed_viewmodel.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ─── External ─────────────────────────────────────────────
  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // ─── Data Sources ─────────────────────────────────────────
  sl.registerLazySingleton<VideoRemoteDataSource>(
    () => VideoRemoteDataSourceImpl(sl()),
  );

  // ─── Repositories ─────────────────────────────────────────
  sl.registerLazySingleton<VideoRepository>(
    () => VideoRepositoryImpl(sl()),
  );

  // ─── Use Cases ────────────────────────────────────────────
  sl.registerLazySingleton(() => FetchVideosUseCase(sl()));
  sl.registerLazySingleton(() => ToggleLikeUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedVideoUseCase(sl()));

  // ─── ViewModels ───────────────────────────────────────────
  sl.registerFactory(
    () => FeedViewModel(
      fetchVideosUseCase: sl(),
      toggleLikeUseCase: sl(),
      getCachedVideoUseCase: sl(),
    ),
  );
  // Upload Service
sl.registerLazySingleton(
      () => UploadVideoService(sl()),
);

// Upload ViewModel
sl.registerLazySingleton(
  () => CloudinaryService(),
);

sl.registerLazySingleton(
  () => VideoFirestoreService(),
);

sl.registerFactory(
  () => UploadVideoViewModel(
    cloudinary: sl<CloudinaryService>(),
    firestore: sl<VideoFirestoreService>(),
  ),
);
}
