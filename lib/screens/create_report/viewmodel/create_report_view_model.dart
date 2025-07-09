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

  // Delivery Report instance
  DeliveryReport newReport = DeliveryReport();

  /// Resets the view model state for a new report
  void resetReportData() {
    resetResponse();
    newReport = DeliveryReport();
  }

  /// Resets API response state
  void resetResponse() {
    _createReportResponse = ApiResponse.initial('Empty data...');
  }

  Future<void> createDeliveryReport() async {
    _createReportResponse = ApiResponse.loading('Creating delivery report ...');
    notifyListeners();

    try {
      await _service.api.createDeliveryReport(newReport);

      _createReportResponse =
          ApiResponse.completed("Report create successfully.");
    } catch (e) {
      _createReportResponse = ApiResponse.error(e.toString());
      logger.w('createDeliveryReport(catch): ${e.toString()}');
    }

    notifyListeners();
  }

  // Used in UI for state management;
  void setOption(String name, ReportOption? option) {
    final item = matchCheckboxItem(name);
    item.selectedOption = option;
    notifyListeners();
  }

  void setComment(String name, String comment) {
    final item = matchCheckboxItem(name);
    item.comment = comment;
    notifyListeners();
  }

  void removeComment(String name) {
    final item = matchCheckboxItem(name);
    item.comment = null;
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

  void setIncludeDamages(bool value) {
    if (value == false) {
      newReport.damagesDescription = null;
      newReport.damagesImages = null;
    }
    newReport.includesDamages = value;
    notifyListeners();
  }

  CheckBoxItem matchCheckboxItem(String name) {
    return newReport.checkboxItems.firstWhere(
      (item) => item.name == name,
      orElse: () => throw Exception("CheckBoxItem with name '$name' not found"),
    );
  }
}
