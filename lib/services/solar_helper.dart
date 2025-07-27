import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';
class SolarHelper {
  static Uri? buildUrl(String? domain, String endpoint,
      {bool includeApiPath = true}) {
    return '$domain/${includeApiPath ? 'api' : ''}$endpoint'.toUri();
  }

  static String? getErrorMessage(body) {
    String? message = body['message'];
    if (body['parameters'] != null && body['parameters'].length > 0) {
      final params = body['parameters'];
      final keys = params is List ? params : params.keys.toList();
      for (var i = 0; i < keys.length; i++) {
        if (params is List) {
          message = message!.replaceAll('%${i + 1}', keys[i].toString());
        } else {
          message =
              message!.replaceAll('%${keys[i]}', params[keys[i]].toString());
        }
      }
    }
    return message;
  }

  static Future<Uint8List> fixExifRotation(Uint8List bytes) async {
    // Save the bytes to a temporary file (flutter_exif_rotation works with file paths)
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp_image.jpg');
    await tempFile.writeAsBytes(bytes);

    // Fix orientation natively (very fast)
    final fixedFile = await FlutterExifRotation.rotateImage(path: tempFile.path);

    // Read the rotated image back into memory
    return await fixedFile.readAsBytes();
  }
}
