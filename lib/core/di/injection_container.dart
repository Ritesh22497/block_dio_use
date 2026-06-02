// lib/core/di/injection_container.dart

import 'package:get_it/get_it.dart';
import '../../data/datasources/demo_seeder.dart';
import '../../data/datasources/local_database.dart';
import '../../data/repositories/video_repository_impl.dart';
import '../../domain/repositories/video_repository.dart';
import '../../domain/usecases/video_usecases.dart';
import '../../presentation/viewmodels/feed_viewmodel.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Database
  sl.registerLazySingleton<LocalDatabase>(() => LocalDatabase());

  // Repository
  sl.registerLazySingleton<VideoRepository>(
    () => VideoRepositoryImpl(sl()),
  );

  // Seeder
  sl.registerLazySingleton(() => DemoSeeder(sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetAllVideosUseCase(sl()));
  sl.registerLazySingleton(() => InsertVideoUseCase(sl()));
  sl.registerLazySingleton(() => UpdateVideoUseCase(sl()));
  sl.registerLazySingleton(() => DeleteVideoUseCase(sl()));
  sl.registerLazySingleton(() => IsDatabaseEmptyUseCase(sl()));

  // ViewModels
  sl.registerFactory(
    () => FeedViewModel(
      getAllVideos: sl(),
      insertVideo: sl(),
      updateVideo: sl(),
      deleteVideo: sl(),
      seeder: sl(),
    ),
  );
}
