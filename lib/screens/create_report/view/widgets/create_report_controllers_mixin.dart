import 'package:flutter/cupertino.dart';

// Step 1 text fields
enum Step1TextFields {
  pvPlantLocation,
  checkingCompany,
  supplier,
  deliverySlipNo,
  logisticsCompany,
  containerNo,
  weatherConditions,
}

mixin CreateReportControllersMixin {
  // Step 1 controllers
  final Map<Step1TextFields, TextEditingController> step1Controllers = {
    for (var field in Step1TextFields.values) field: TextEditingController(),
  };

  final List<GlobalKey<FormState>> formKeys =
      List.generate(4, (_) => GlobalKey<FormState>());
}

// Step 3 checkbox states
enum ReportOption { ok, notOk, na }

// Step 3 checklist item
class Step3Item {
  ReportOption? selectedOption;
  String? comment;

  Step3Item({
    this.selectedOption,
    this.comment,
  });
}

enum ReportImagesFields {
  truckLicensePlate,
  trailerLicensePlate,
  proofOfDelivery,
  cmr,
  deliverySlip,
}
