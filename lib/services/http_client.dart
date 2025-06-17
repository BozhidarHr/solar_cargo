import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:http/http.dart' as http;
import 'package:solar_cargo/services/services.dart';

import '../screens/common/logger.dart';

/// enable network proxy
const debugNetworkProxy = false;
typedef RequestExecutor = Future<http.Response> Function(String? token);

class HttpClientSetting {
  static String webProxy = '';

  static Uri settingProxy(Uri uri) {
    var url = uri;

    if (foundation.kIsWeb &&
        '$url'.contains(HttpClientSetting.webProxy) == false) {
      final urlText =
      '$url'.replaceAll('http://', '').replaceAll('https://', '');

      final proxyURL = '${HttpClientSetting.webProxy}$urlText';
      url = Uri.parse(proxyURL);
    }

    return url;
  }
}

class HttpBase extends http.BaseClient {
  final http.Client _client = http.Client();
  HttpBase();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request);
  }
}

Future<http.Response> sendWithAuth(RequestExecutor executor) async {
  var services = Services();
  String? token = services.api.customerToken;
  http.Response response = await executor(token);

  if (response.statusCode == 401) {
    // Try to refresh token
    final newToken = await services.api.updateToken();
    services.api.setCustomerToken(newToken); // Add this setter in SolarServices

    // Retry the request with new token
    response = await executor(newToken);
  }

  return response;
}

Future<http.Response> _makeRequest(Future<http.Response> request) async {
  try {
    var response = await request;
    if (response.statusCode == 404) {
      throw SocketException(response.reasonPhrase ?? 'Not Found');
    }
    return response;
  } on SocketException catch (e) {
    if (e.message.contains('Failed host lookup')) {
      throw 'No Internet Connection';
    }
    throw e.message;
  }
}

/// The default http GET that support Logging
Future<http.Response> httpGet(
    Uri uri, {
      Map<String, String>? headers,
      bool enableDio = false,
      bool refreshCache = false,
    }) async {
  final startTime = DateTime.now();
  var url = HttpClientSetting.settingProxy(uri);

  if (enableDio) {
    try {
      final res = await Dio().get(url.toString(),
          options: Options(headers: headers, responseType: ResponseType.plain));
      printLog('GET:$url', startTime);
      final response = http.Response(res.toString(), res.statusCode!);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final response =
        http.Response(e.response.toString(), e.response!.statusCode!);
        return response;
      } else {
        // ignore: only_throw_errors
        throw e.message ?? '';
      }
    }
  } else {
    if (refreshCache) {
      url = url.replace(queryParameters: {
        ...url.queryParameters,
        'refresh': '${DateTime.now().millisecondsSinceEpoch}'
      });
    }
    var uri = url;
    if (foundation.kIsWeb) {
      final proxyURL = '$url';
      uri = Uri.parse(proxyURL);
    }
    var response = await _makeRequest(http.get(uri, headers: headers));
    printLog('♻️ GET:$url', startTime);
    return response;
  }
}

/// The default http POST that support Logging
Future<http.Response> httpPost(
    Uri uri, {
      Map<String, String>? headers,
      Object? body,
      bool enableDio = false,
    }) async {
  final startTime = DateTime.now();
  var url = HttpClientSetting.settingProxy(uri);

  if (enableDio) {
    try {
      final res = await Dio().post(url.toString(),
          options: Options(headers: headers, responseType: ResponseType.plain),
          data: body);
      printLog('🔼 POST:$url', startTime);

      final headersRes = <String, String>{};
      res.headers.forEach((name, values) {
        headersRes.addAll({name: values.join()});
      });

      final response = http.Response(
        res.toString(),
        res.statusCode!,
        headers: headersRes,
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final response =
        http.Response(e.response.toString(), e.response!.statusCode!);
        return response;
      } else {
        // ignore: only_throw_errors
        throw e.message ?? 'error';
      }
    }
  } else {
    var response =
    await _makeRequest(http.post(url, headers: headers, body: body));
    printLog('🔼 POST:$url', startTime);
    return response;
  }
}

/// The default http PUT that support Logging
Future<http.Response> httpPut(Uri uri,
    {Map<String, String>? headers,
      Object? body,
      bool enableDio = false}) async {
  final startTime = DateTime.now();
  var url = HttpClientSetting.settingProxy(uri);

  if (enableDio) {
    try {
      final res = await Dio().put(url.toString(),
          options: Options(headers: headers, responseType: ResponseType.plain),
          data: body);
      printLog('🔼 PUT:$url', startTime);
      final response = http.Response(res.toString(), res.statusCode!);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final response =
        http.Response(e.response.toString(), e.response!.statusCode!);
        return response;
      } else {
        // ignore: only_throw_errors
        throw e.message ?? 'error';
      }
    }
  } else {
    var response =
    await _makeRequest(http.put(url, headers: headers, body: body));
    printLog('🔼 PUT:$url', startTime);

    return response;
  }
}

/// The default http PUT that support Logging
Future<http.Response> httpDelete(Uri uri,
    {Map<String, String>? headers,
      Object? body,
      bool enableDio = false}) async {
  final startTime = DateTime.now();
  var url = HttpClientSetting.settingProxy(uri);

  if (enableDio) {
    try {
      final res = await Dio().delete(url.toString(),
          options: Options(headers: headers, responseType: ResponseType.plain),
          data: body);
      printLog('DELETE:$url', startTime);
      final response = http.Response(res.toString(), res.statusCode!);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final response =
        http.Response(e.response.toString(), e.response!.statusCode!);
        return response;
      } else {
        // ignore: only_throw_errors
        throw e.message ?? 'error';
      }
    }
  } else {
    var response =
    await _makeRequest(http.delete(url, headers: headers, body: body));
    printLog('DELETE:$url', startTime);
    return response;
  }
}

/// The default http PATCH that support Logging
Future<http.Response> httpPatch(Uri uri,
    {Map<String, String>? headers,
      Object? body,
      bool enableDio = false}) async {
  final startTime = DateTime.now();
  var url = HttpClientSetting.settingProxy(uri);

  if (enableDio) {
    try {
      final res = await Dio().patch(url.toString(),
          options: Options(headers: headers, responseType: ResponseType.plain),
          data: body);
      printLog('PATCH:$url', startTime);
      final response = http.Response(res.toString(), res.statusCode!);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final response =
        http.Response(e.response.toString(), e.response!.statusCode!);
        return response;
      } else {
        // ignore: only_throw_errors
        throw e.message ?? 'error';
      }
    }
  } else {
    var response =
    await _makeRequest(http.patch(url, headers: headers, body: body));
    printLog('PATCH:$url', startTime);

    return response;
  }
}


