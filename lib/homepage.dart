import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:storage_access_demo/permission/permission_handler.dart';

import 'notification/notification_utils.dart';
import 'singleDonwloadFile/donwloadmanagercontroller.dart';

class HomePage extends StatefulWidget {
  Directory? directory;
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DownloadManagerController downloadFileService = DownloadManagerController();
  String URL =
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  double progress = 0;
  // SaveThePhotoVideo savetophoto = SaveThePhotoVideo();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: ElevatedButton(
              onPressed: () {
                debugPrint('click');
                saveFile();
              },
              child: const Text('Download')),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: LinearProgressIndicator(
            backgroundColor: Colors.white,
            color: Colors.white,

            valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.red), // Set the progress color
            value: progress / 100,
          ),
        ),
        Text(
          progress.toInt().toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        )
      ],
    );
  }

  void saveFile() async {
    bool hasPermission = await PermissionHandler.requestPermission();
    if (!hasPermission) {
      debugPrint('Permission denied');
      return;
    }
    String savePath = await getSavePath();
    debugPrint('new path is $savePath');
    int taskId = 1;
    downloadFileService.download(
      taskId: taskId,
      url: URL,
      savePath: savePath,
      progressCallback: (progressvalue) {
        setState(() {
          progress = progressvalue;
        });
        NotificationUtils.showProgressNotification(
            taskId: taskId, progress: progress);
        debugPrint('progressvalue-- $progressvalue');
      },
      completionCallback: () {
        debugPrint('completed progress done');
        NotificationUtils.cancelNotification(taskId);
      },
    );
  }
}

Future<String> getSavePath() async {
  late File newPath;
  Directory? directory;
  String? createdPath;
  if (Platform.isAndroid) {
    directory = await getExternalStorageDirectory();
    createdPath =
        '${directory!.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
    newPath = File(createdPath);
    debugPrint("android - $newPath");
  } else if (Platform.isIOS) {
    directory = await getTemporaryDirectory();
    newPath =
        File('${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4');
    debugPrint("IOS - $newPath");
    // await saveToGallery(newPath);
  }
  if (!directory!.existsSync()) {
    await directory.create();
  }
  if (!await newPath.exists()) {
    await newPath.create();
  }
  return newPath.path;
}
