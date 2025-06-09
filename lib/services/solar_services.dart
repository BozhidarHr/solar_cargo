import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:solar_cargo/services/solar_helper.dart';

import '../models/jwt_keys.dart';
import '../screens/view_reports/model/delivery_report.dart';

class SolarServices {
  final String domain;
  final String accessToken;

  SolarServices({
    required this.domain,
    required this.accessToken,
  });

  String? _customerToken;

  Future<JwtKeys> login(String username, String password) async {
    try {
      var url = SolarHelper.buildUrl(
        domain,
        '/auth/login',
      );
      var body = {
        'username': username,
        'password': password,
      };
      var response = await http.post(
        url!,
        body: convert.jsonEncode(body),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
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

      final refreshToken = responseBody?['refresh'];
      final bearerToken = responseBody?['access'];

      if (bearerToken == null || bearerToken.isEmpty) {
        throw Exception('Bearer token not found in response');
      }
      _customerToken = bearerToken;
      return JwtKeys(
        bearerToken: bearerToken,
        refreshToken: refreshToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateToken(String refreshToken) async {
    try {
      var url = SolarHelper.buildUrl(
        domain,
        '/auth/refresh',
      );
      var body = {
        "refresh": refreshToken
      };
      var response = await http.post(
        url!,
        body: convert.jsonEncode(body),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
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

      final bearerToken = responseBody?['access'];
      _customerToken = bearerToken;
      return bearerToken;
    } catch (e) {
      rethrow;
    }
  }


  Future<List<DeliveryReport>> fetchDeliveryReports() async {
    try {
      var url = SolarHelper.buildUrl(
        domain,
        '/delivery-reports',
      );
      var response = await http.get(url!,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $_customerToken'});
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
