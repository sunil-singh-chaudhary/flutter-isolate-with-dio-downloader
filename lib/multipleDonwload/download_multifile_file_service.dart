import 'task.dart';

class DownloadManager {
  static final _taskMap = {};

  static void startDownload(int taskId, String url, String savePath,
      Function(double) progressCallback, Function() completionCallback) {
    final task = DownloadTask(
      taskId: taskId,
      url: url,
      savePath: savePath,
      progressCallback: progressCallback,
      completionCallback: completionCallback,
    );

    _taskMap[taskId] = task;
    task.start();
  }

  static void pauseDownload(int taskId) {
    final task = _taskMap[taskId];
    task?.pause();
  }

  static void resumeDownload(int taskId) {
    final task = _taskMap[taskId];
    task?.resume();
  }

  static void cancelDownload(int taskId) {
    final task = _taskMap[taskId];
    task?.cancel();
    _taskMap.remove(taskId);
  }
}


// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Download Example'),
//       ),
//       body: ListView.builder(
//         itemCount: 5, // Number of items in the list
//         itemBuilder: (context, index) {
//           final taskId = index + 1; // Generate unique task ID

//           return ListTile(
//             title: Text('File $taskId'),
//             onTap: () {
//               // Start the download on item tap
//               DownloadManager.startDownload(
//                 taskId,
//                 'https://example.com/file$taskId.pdf',
//                 '/path/to/save/file$taskId.pdf',
//                 (double progress) {
//                   // Handle progress updates for the specific task ID
//                   print('Task $taskId - Progress: ${progress.toStringAsFixed(2)}');
//                 },
//                 () {
//                   // Handle completion for the specific task ID
//                   print('Task $taskId - Completed');
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
