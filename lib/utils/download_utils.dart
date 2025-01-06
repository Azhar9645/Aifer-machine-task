import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadUtils {
  static Future<void> downloadImage(String imageUrl) async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      try {
        final savedDir = '/storage/emulated/0/Download';

        await FlutterDownloader.cancelAll();

        String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

        await FlutterDownloader.enqueue(
          url: imageUrl,
          savedDir: savedDir,
          fileName: fileName,
          showNotification: true,
          openFileFromNotification: true,
        );
      } catch (e) {
        // Handle error if needed
        print("Download failed: $e");
      }
    } else {
      print("Permission denied");
    }
  }

  

}
