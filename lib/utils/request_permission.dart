import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

Future<void> requestStoragePermission(BuildContext context) async {
  final status = await Permission.storage.request();
  if (status.isGranted) {
  } else {
    _showPermissionDeniedDialog(context);
  }
}

// Show a dialog when permission is denied
void _showPermissionDeniedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Permission Denied"),
        content: const Text(
            "Storage permission is required to download images. Please grant permission in the app settings."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openAppSettings();
            },
            child: const Text("Go to Settings"),
          ),
        ],
      );
    },
  );
}

// Open app settings to allow the user to grant the permission
void _openAppSettings() async {
  await openAppSettings(); // This will open the app's settings page
}
