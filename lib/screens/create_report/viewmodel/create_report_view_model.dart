import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/view_reports/model/delivery_report.dart';

import '../../../../services/services.dart';
import '../../../services/api_response.dart';
import '../../common/logger.dart';

class CreateReportViewModel with ChangeNotifier {
  final Services _service = Services();

  ApiResponse _createReportResponse = ApiResponse.initial('Empty data');

  ApiResponse get createReportResponse {
    return _createReportResponse;
  }

  Future<void> createDeliveryReport() async {
    _createReportResponse =
        ApiResponse.loading('Creating delivery report ...');
    notifyListeners();

    try {
      final DeliveryReport deliveryReports =
      await _service.api.createDeliveryReports();

      _createReportResponse = ApiResponse.completed(deliveryReports);
    } catch (e) {
      _createReportResponse = ApiResponse.error(e.toString());
      logger.w(
        'createDeliveryReport(catch): ${e.toString()}',
      );
    }

    notifyListeners();
  }
}
