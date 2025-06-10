import 'dart:io';

import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/view_reports/model/delivery_report.dart';

import '../view/widgets/create_report_controllers_mixin.dart';

class CreateReportViewModel with ChangeNotifier {
  final DeliveryReport newReport = DeliveryReport();
  File? truckLicensePlateImage;
  File? trailerLicensePlateImage;

  void setStep1Data({
    required Map step1Controllers,
  }) {
    newReport
      ..location = step1Controllers[Step1Field.pvPlantLocation]?.text ?? ''
      ..checkingCompany =
          step1Controllers[Step1Field.checkingCompany]?.text ?? ''
      ..supplier = step1Controllers[Step1Field.supplier]?.text ?? ''
      ..deliverySlipNumber =
          step1Controllers[Step1Field.deliverySlipNo]?.text ?? ''
      ..logisticCompany =
          step1Controllers[Step1Field.logisticsCompany]?.text ?? ''
      ..containerNumber = step1Controllers[Step1Field.containerNo]?.text ?? ''
      ..weatherConditions =
          step1Controllers[Step1Field.weatherConditions]?.text ?? ''
      ..truckLicencePlateFile = truckLicensePlateImage
      ..trailerLicencePlateFile = trailerLicensePlateImage;
  }
// final Services _service = Services();
//
// ApiResponse _createReportResponse = ApiResponse.initial('Empty data');
//
// ApiResponse get createReportResponse {
//   return _createReportResponse;
// }

// Future<void> createDeliveryReport() async {
//   _createReportResponse =
//       ApiResponse.loading('Creating delivery report ...');
//   notifyListeners();
//
//   try {
//     final DeliveryReport deliveryReports =
//     await _service.api.createDeliveryReports();
//
//     _createReportResponse = ApiResponse.completed(deliveryReports);
//   } catch (e) {
//     _createReportResponse = ApiResponse.error(e.toString());
//     logger.w(
//       'createDeliveryReport(catch): ${e.toString()}',
//     );
//   }
//
//   notifyListeners();
// }
}
