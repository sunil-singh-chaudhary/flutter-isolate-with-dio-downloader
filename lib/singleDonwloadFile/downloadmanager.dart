import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DownloadManager {
  static final isolateMap = {};
  // Map to store isolates with task IDs
  static Future<void> downloadFile(List<Object> args) async {
    final int taskId = args[0] as int;
    final String url = args[1] as String;
    final String savePath = args[2] as String;
    final SendPort sendPort = args[3] as SendPort;

    final dio = Dio();
    final file = File(savePath);
    bool isPaused = false;
    bool isCancelled = false;

    if (!await file.exists()) {
      await file.create();
      debugPrint('file not present created');
    }

    try {
      await file.create(recursive: true);
      isolateMap[taskId] = Isolate.current;

      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Range': 'bytes=${file.lengthSync()}-'},
        ),
        onReceiveProgress: (received, total) {
          if (!isPaused && !isCancelled) {
            final progress = received / total * 100;
            sendPort.send(progress);
          }
        },
      );

      if (!isCancelled) {
        await file.writeAsBytes(response.data, mode: FileMode.write);
        sendPort.send('completed');
      }
    } catch (e) {
      sendPort
          .send('error in port sended--:${e.toString()}'); // Send error message
    } finally {
      isolateMap.remove(taskId);
    }
  }

  static void cancelDownload(int taskId) {
    final isolate = isolateMap[taskId];
    isolate?.kill(priority: Isolate.beforeNextEvent);
    isolateMap.remove(taskId);
  }

  static void pauseDownload(int taskId) {
    final isolate = isolateMap[taskId];
    isolate?.pause(isolate.pauseCapability!);
  }

  static void resumeDownload(int taskId) {
    final isolate = isolateMap[taskId];
    isolate?.resume(isolate.pauseCapability!);
  }
}
