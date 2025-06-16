import 'dart:io';

import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/create_report/models/checkbox_comment.dart';
import 'package:solar_cargo/screens/view_reports/model/delivery_report.dart';

import '../../../services/api_response.dart';
import '../../../services/services.dart';
import '../../common/logger.dart';
import '../models/delivery_item.dart';
import '../models/delivery_item_controllers.dart';
import '../view/widgets/create_report_mixin.dart';

part 'create_report_view_model_extension.dart';

class CreateReportViewModel with ChangeNotifier {
  final Services _service = Services();

  // Api response
  ApiResponse _createReportResponse = ApiResponse.initial('Empty data');

  ApiResponse get createReportResponse {
    return _createReportResponse;
  }

  // initialise step3 items
  final step3CheckboxItems = CheckBoxItem.defaultStep3Items();

  // init report
  DeliveryReport newReport = DeliveryReport();

  final Map<ReportImagesFields, File?> images = {};
  List<File> optionalImages = [];

  void resetReportData() {
    // reset all text fields
    newReport = DeliveryReport();
    // reset all images
    clearAllImages();
    // reset checkboxes
    clearCheckboxesData();
  }

  void setFinalData(
      Map<Step1TextFields, TextEditingController> step1Controllers,
      List<DeliveryItemControllers> items) {
    setStep1Data(step1Controllers);
    setStep2Data(items);
    setStep3Data();
    setStep4Data();
  }

  Future<void> createDeliveryReport() async {
    _createReportResponse = ApiResponse.loading('Creating delivery report ...');
    notifyListeners();

    try {
      final response = await _service.api.createDeliveryReports(newReport);

      _createReportResponse = ApiResponse.completed(response);
    } catch (e) {
      _createReportResponse = ApiResponse.error(e.toString());
      logger.w(
        'createDeliveryReport(catch): ${e.toString()}',
      );
    }

    notifyListeners();
  }

  // Used in UI for state management;
  void setOption(String label, ReportOption? option) {
    step3CheckboxItems[label]?.selectedOption = option;
    notifyListeners();
  }

  void setComment(String label, String comment) {
    step3CheckboxItems[label]?.comment = comment;
    notifyListeners();
  }

  void removeComment(String label) {
    step3CheckboxItems[label]?.comment = null;
    notifyListeners();
  }
}
