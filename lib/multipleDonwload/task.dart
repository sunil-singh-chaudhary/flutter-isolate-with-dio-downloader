import 'package:dio/dio.dart';

class DownloadTask {
  final int taskId;
  final String url;
  final String savePath;
  final Function(double) progressCallback;
  final Function() completionCallback;

  bool _isDownloading = false;
  bool _isPaused = false;
  bool _isCancelled = false;

  DownloadTask({
    required this.taskId,
    required this.url,
    required this.savePath,
    required this.progressCallback,
    required this.completionCallback,
  });

  Future<void> _download() async {
    final dio = Dio();
    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (!_isPaused && !_isCancelled) {
          final progress = received / total;
          progressCallback(progress);
        }
      },
    );

    if (!_isCancelled) {
      // Handle completion
      completionCallback();
    }
  }

  void start() {
    if (!_isDownloading) {
      _isDownloading = true;
      _download();
    }
  }

  void pause() {
    if (_isDownloading && !_isPaused) {
      _isPaused = true;
    }
  }

  void resume() {
    if (_isDownloading && _isPaused) {
      _isPaused = false;
      _download();
    }
  }

  void cancel() {
    if (_isDownloading) {
      _isCancelled = true;
    }
  }
}
