import 'package:flutter/cupertino.dart';

enum Step1TextFields {
  pvPlantLocation,
  checkingCompany,
  supplier,
  deliverySlipNo,
  logisticsCompany,
  containerNo,
  weatherConditions,
}

enum ReportOption { ok, notOk, na }

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
  cmr,
  deliverySlip,
}

mixin CreateReportControllersMixin {
  final Map<Step1TextFields, TextEditingController> step1Controllers = {
    for (var field in Step1TextFields.values) field: TextEditingController(),
  };

  final List<GlobalKey<FormState>> formKeys =
      List.generate(4, (_) => GlobalKey<FormState>());
}
