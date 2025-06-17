import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/create_report/models/checkbox_comment.dart';
import 'package:solar_cargo/screens/view_reports/model/delivery_report.dart';

import '../../../services/api_response.dart';
import '../../../services/services.dart';
import '../../common/logger.dart';
import '../models/delivery_item.dart';

class CreateReportViewModel with ChangeNotifier {
  final Services _service = Services();

  // API response state
  ApiResponse _createReportResponse = ApiResponse.initial('Empty data');

  ApiResponse get response => _createReportResponse;

  // Step 3 Checkbox Items
  final step3CheckboxItems = CheckBoxItem.defaultStep3Items();

  // Delivery Report instance
  DeliveryReport newReport = DeliveryReport();

  /// Resets the view model state for a new report
  void resetReportData() {
    resetResponse();
    newReport = DeliveryReport();
    clearCheckboxesData();
  }

  /// Resets API response state
  void resetResponse() {
    _createReportResponse = ApiResponse.initial('Empty data...');
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

  void setCheckboxData() {
    newReport.checkboxItems = step3CheckboxItems.values.toList();
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

  void addDeliveryItem() {
    newReport.deliveryItems.add(DeliveryItem(name: '', amount: null));
    notifyListeners();
  }

  void updateItem(int index, {String? name, int? amount}) {
    var deliveryItems = newReport.deliveryItems;
    if (index >= 0 && index < deliveryItems.length) {
      if (name != null) deliveryItems[index].name = name;
      if (amount != null) deliveryItems[index].amount = amount;
    }
  }

  void removeItem(int index) {
    if (index > 0 && index < newReport.deliveryItems.length) {
      newReport.deliveryItems.removeAt(index);
      notifyListeners();
    }
  }

  void clearCheckboxesData() {
    for (var item in step3CheckboxItems.values) {
      item
        ..selectedOption = null
        ..comment = null;
    }
  }
}
