import 'dart:io';

import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/view_reports/model/delivery_report.dart';

import '../view/widgets/create_report_controllers_mixin.dart';

class CreateReportViewModel with ChangeNotifier {
  DeliveryReport newReport = DeliveryReport();
  final Map<ReportImagesFields, File?> images = {};
List<File> optionalImages = [];
  void setImage(ReportImagesFields field, File? image) {
    images[field] = image;
  }


  void resetReportData() {
    newReport = DeliveryReport();
    resetImages();
    clearStep3Items();
  }

  void resetImages() => images.clear();

  void setStep1Data({
    required Map step1Controllers,
  }) {
    newReport
      ..location = step1Controllers[Step1TextFields.pvPlantLocation]?.text ?? ''
      ..checkingCompany =
          step1Controllers[Step1TextFields.checkingCompany]?.text ?? ''
      ..supplier = step1Controllers[Step1TextFields.supplier]?.text ?? ''
      ..deliverySlipNumber =
          step1Controllers[Step1TextFields.deliverySlipNo]?.text ?? ''
      ..logisticCompany =
          step1Controllers[Step1TextFields.logisticsCompany]?.text ?? ''
      ..containerNumber = step1Controllers[Step1TextFields.containerNo]?.text ?? ''
      ..weatherConditions =
          step1Controllers[Step1TextFields.weatherConditions]?.text ?? ''
      ..truckLicencePlateFile = images[ReportImagesFields.truckLicensePlate]
      ..trailerLicencePlateFile = images[ReportImagesFields.trailerLicensePlate];
  }

  final Map<String, Step3Item> step3Items = {
    'Load properly secured': Step3Item(),
    'Goods according to delivery and PO, amount and indentity': Step3Item(),
    'Packaging sufficient and stable enough': Step3Item(),
    'Delivery without damages': Step3Item(),
    'Suitable machines for unloading/handling present': Step3Item(),
    'Delivery slip scanned, uploaded and filed': Step3Item(),
    'Inspection Report scanned, uploaded and filed': Step3Item(),
  };

  void clearStep3Items() {
    for (var item in step3Items.values) {
      item
        ..selectedOption = null
        ..comment = null;
    }
    notifyListeners();

  }

  void setOption(String label, ReportOption? option) {
    step3Items[label]?.selectedOption = option;
    notifyListeners();
  }

  void setComment(String label, String comment) {
    step3Items[label]?.comment = comment;
    notifyListeners();
  }

  void removeComment(String label) {
    step3Items[label]?.comment = null;
    notifyListeners();
  }
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
