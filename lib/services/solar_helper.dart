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
}
