// lib/core/errors/failures.dart

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'Database error']);
}

class VideoPlaybackFailure extends Failure {
  const VideoPlaybackFailure([super.message = 'Video playback error']);
}

class FilePickerFailure extends Failure {
  const FilePickerFailure([super.message = 'Could not pick file']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unknown error']);
}
