// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:background_fetch/background_fetch.dart';

// class SaveThePhotoVideo {
//   String URL =
//       "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
//   Dio dio = Dio();

//   void startDownload() {
//     BackgroundFetch.configure(
//       BackgroundFetchConfig(
//         minimumFetchInterval: 15, // Minimum interval between fetch events
//         stopOnTerminate:
//             false, // Set to true to stop background_fetch on app termination.
//         enableHeadless:
//             true, // Set to true to run the task in a headless background isolate.
//         requiresBatteryNotLow:
//             false, // Set to true to only perform background fetches when the device's battery level is not low.
//         requiresCharging:
//             false, // Set to true to only perform background fetches when the device is charging.
//         requiresStorageNotLow:
//             false, // Set to true to only perform background fetches when the device's available storage is not low.
//       ),
//       (String taskId) async {
//         await saveToApplicationFolder();
//         BackgroundFetch.finish(taskId);
//       },
//     );
//     BackgroundFetch.start();
//   }

//   Future<bool> saveToApplicationFolder() async {
//     late File newPath;
//     Directory? directory;
//     String? createdPath;
//     if (Platform.isAndroid) {
//       directory = await getExternalStorageDirectory();
//       createdPath =
//           '${directory!.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
//       newPath = File(createdPath);
//       debugPrint("android - $newPath");
//     } else if (Platform.isIOS) {
//       directory = await getTemporaryDirectory();
//       newPath = File(
//           '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4');
//       debugPrint("IOS - $newPath");
//       await saveToGallery(newPath);
//     }
//     if (!directory!.existsSync()) {
//       await directory.create();
//     }
//     if (!await newPath.exists()) {
//       await newPath.create();
//     }
//     await dio.download(
//       URL,
//       createdPath,
//       onReceiveProgress: (count, total) {
//         debugPrint('File downloaded progress--> ${total ~/ count}');
//       },
//     );

//     debugPrint('newPath--$newPath');

//     return true;
//   }

//   static Future<void> saveToGallery(File file) async {
//     final result = await ImageGallerySaver.saveFile(file.path);
//     debugPrint(result);
//   }
// }
