import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  /// Ensure we have sufficient permissions to write to external storage.
  /// Returns true if we can write to the chosen location.
  static Future<bool> ensureStoragePermission(BuildContext context) async {
    // On non-Android platforms we assume permission is available (desktop/iOS
    // will use their own frameworks / app storage).
    if (!Platform.isAndroid) return true;

    // Request the standard storage permission first.
    final status = await Permission.storage.status;
    if (status.isGranted) return true;

    final res = await Permission.storage.request();
    if (res.isGranted) return true;

    // Permission denied or restricted — the caller should handle UI to let the
    // user pick a folder as a fallback. Return false to indicate lack of
    // permission.
    return false;
  }

  /// Show a system folder picker and return the chosen directory path or null.
  static Future<String?> promptForDirectory() async {
    final chosen = await FilePicker.platform.getDirectoryPath();
    return chosen;
  }

  /// Save a preferred export directory path for later use.
  static Future<void> setPreferredExportDirectory(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferred_export_dir', path);
  }

  /// Get saved preferred export directory path, or null if not set.
  static Future<String?> getPreferredExportDirectory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('preferred_export_dir');
  }
}