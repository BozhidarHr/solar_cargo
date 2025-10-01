import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

  ApiResponse _recognisePlateResponse = ApiResponse.initial('Empty data');

  ApiResponse get recognisePlateResponse => _recognisePlateResponse;

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


  Future<void> recognisePlate(File? truckImage, File? trailerImage) async {
    _recognisePlateResponse = ApiResponse.loading('Recognising plate ...');
    notifyListeners();

    if (truckImage == null || trailerImage == null) {
      return;
    }

    try {
      final data = await _service.api.plateRecognition(
          trailerImage: trailerImage, truckImage: truckImage);

      _recognisePlateResponse =
          ApiResponse.completed("recognisePlate successfully.");

      newReport.licencePlateTruck = data['truckPlateText'];
      newReport.licencePlateTrailer = data['trailerPlateText'];
    } catch (e) {
      _recognisePlateResponse = ApiResponse.error(e.toString());
      newReport.licencePlateTruck = '';
      newReport.licencePlateTrailer = '';
      logger.w('recognisePlate(catch): ${e.toString()}');
    }

    notifyListeners();
  }

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

  Future<void> saveReportToStorage() async {
    final box = await Hive.openBox('delivery_reports');
    await box.put('current_report', newReport.toLocalJson());
  }

  Future<void> loadReportFromStorage() async {
    final box = await Hive.openBox('delivery_reports');
    final saved = box.get('current_report');
    if (saved != null) {
      newReport = DeliveryReport.fromLocalJson(Map<String, dynamic>.from(saved));
      notifyListeners();
    }
  }
}

