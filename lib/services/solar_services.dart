import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:solar_cargo/services/solar_helper.dart';

import '../screens/common/logger.dart';
import '../screens/view_reports/model/delivery_report.dart';

class SolarServices {
  final String domain;
  final String accessToken;

  SolarServices({
    required this.domain,
    required this.accessToken,
  });

  Future<String> login(String username, String password) async {
    try {
      var url = SolarHelper.buildUrl(
        domain,
        '/auth/login/',
      );
      var body = {
        'username': username,
        'password': password,
      };
      var response = await http.post(
        url!,
        body: convert.jsonEncode(body),
        headers: {
          HttpHeaders.authorizationHeader: accessToken,
          HttpHeaders.contentTypeHeader: 'application/json'
        },
      );

      if (response.body.isEmpty) {
        throw Exception('Empty response from server');
      }
      var responseBody = convert.jsonDecode(response.body);

      if (response.statusCode != 200) {
        if (responseBody is Map && responseBody['message'] != null) {
          throw Exception(SolarHelper.getErrorMessage(responseBody));
        }
        throw Exception(
            'Unknown error occurred with status code ${response.statusCode}');
      }

      final apiKey = responseBody?['api_key'];

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('API key not found in response');
      }

      return apiKey;
    } catch (e) {
      printLog('Error in login: $e');
      rethrow;
    }
  }

  Future<List<DeliveryReport>> fetchDeliveryReports() async {
    try {
      var url = SolarHelper.buildUrl(
        domain,
        '/delivery-reports',
      );
      var response = await http
          .get(url!, headers: {HttpHeaders.authorizationHeader: accessToken});
      var responseBody = convert.jsonDecode(response.body);
      var list = <DeliveryReport>[];

      if (response.statusCode != 200) {
        if (responseBody is Map && responseBody['message'] != null) {
          throw Exception(SolarHelper.getErrorMessage(responseBody));
        }
        throw Exception(
            'Unknown error occurred with status code ${response.statusCode}');
      }
      for (var item in responseBody) {
        var report = DeliveryReport.fromJson(item);
        list.add(report);
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<DeliveryReport> createDeliveryReports() async {
    try {
      var url = SolarHelper.buildUrl(
        domain,
        '/delivery-reports',
      );
      var response = await http
          .post(url!, headers: {HttpHeaders.authorizationHeader: accessToken});
      var responseBody = convert.jsonDecode(response.body);

      if (response.statusCode != 200) {
        if (responseBody is Map && responseBody['message'] != null) {
          throw Exception(SolarHelper.getErrorMessage(responseBody));
        }
        throw Exception(
            'Unknown error occurred with status code ${response.statusCode}');
      }
      return DeliveryReport.fromJson(responseBody);
    } catch (e) {
      rethrow;
    }
  }
}
