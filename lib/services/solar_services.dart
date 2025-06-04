import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:solar_cargo/services/solar_helper.dart';

import '../screens/view_reports/model/delivery_report.dart';

class SolarServices {
  final String domain;
  final String accessToken;

  SolarServices({
    required this.domain,
    required this.accessToken,
  });

  Future<List<DeliveryReport>> fetchDeliveryReports() async {
    try {
      var url = SolarHelper.buildUrl(
        domain,
        '/delivery-reports',
      );
      var response = await http.get(url!, headers: {
        HttpHeaders.authorizationHeader: accessToken
      });
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
}
