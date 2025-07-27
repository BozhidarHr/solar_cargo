import 'package:exif/exif.dart';
import 'package:flutter/services.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';
import 'package:image/image.dart' as img;
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
    final tags = await readExifFromBytes(bytes);
    int orientation = 1;

    if (tags != null && tags.containsKey('Image Orientation')) {
      final orientationString = tags['Image Orientation']?.printable ?? '1';
      orientation = int.tryParse(orientationString.split(' ')[0]) ?? 1;
    }

    final originalImage = img.decodeImage(bytes);
    if (originalImage == null) return bytes;

    img.Image fixedImage;

    switch (orientation) {
      case 3:
        fixedImage = img.copyRotate(originalImage, angle: 180);
        break;
      case 6:
        fixedImage = img.copyRotate(originalImage, angle: 90);
        break;
      case 8:
        fixedImage = img.copyRotate(originalImage, angle: -90);
        break;
      default:
        fixedImage = originalImage;
    }

    return Uint8List.fromList(img.encodeJpg(fixedImage, quality: 100));
  }

}
