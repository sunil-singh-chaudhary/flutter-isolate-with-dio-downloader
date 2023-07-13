import 'dart:isolate';

import 'package:flutter/material.dart';

import 'downloadmanager.dart';

class DownloadManagerController {
  ReceivePort receivePort = ReceivePort();
  late Isolate _isolate;

  Future<void> download(
      {required int taskId,
      required String url,
      required String savePath,
      required Function(double) progressCallback,
      required Function() completionCallback}) async {
    final sendPort = receivePort.sendPort;

    _isolate = await Isolate.spawn(
      //call isolate
      DownloadManager.downloadFile,
      [taskId, url, savePath, sendPort],
    ).then((isolate) {
      // Store the isolate with the task ID
      return DownloadManager.isolateMap[taskId] = isolate;
    });

    receivePort.listen((dynamic message) {
      if (message is double) {
        progressCallback(message);
      } else if (message == 100) {
        _isolate.kill(priority: Isolate.immediate);
        completionCallback();
      } else if (message is String) {
        debugPrint('error - $message');
        // Handle error
      }
    });

    // // To cancel the download
    // DownloadManager.cancelDownload(taskId);

    // // To pause the download
    // DownloadManager.pauseDownload(taskId);

    // // To resume the download
    // DownloadManager.resumeDownload(taskId);
  }
}
