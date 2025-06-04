import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/view_reports/model/delivery_report.dart';

import '../../../../services/services.dart';
import '../../../services/api_response.dart';
import '../../common/logger.dart';

class ViewReportsViewModel with ChangeNotifier {
  final Services _service = Services();

  ApiResponse _fetchReportsResponse = ApiResponse.initial('Empty data');

  ApiResponse get fetchReportsResponse {
    return _fetchReportsResponse;
  }

  Future<void> fetchDeliveryReports() async {
    _fetchReportsResponse =
        ApiResponse.loading('Fetching delivery reports ...');
    notifyListeners();

    try {
      final List<DeliveryReport> deliveryReports =
          await _service.api.fetchDeliveryReports();

      _fetchReportsResponse = ApiResponse.completed(deliveryReports);
    } catch (e) {
      _fetchReportsResponse = ApiResponse.error(e.toString());
      logger.w(
        'fetchDeliveryReports(catch): ${e.toString()}',
      );
    }

    notifyListeners();
  }
}
