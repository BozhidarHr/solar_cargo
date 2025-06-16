import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

mixin CreateReportMixin {
  // Step 1 controllers
  final Map<Step1TextFields, TextEditingController> step1Controllers = {
    for (var field in Step1TextFields.values) field: TextEditingController(),
  };

  final List<GlobalKey<FormState>> formKeys =
      List.generate(4, (_) => GlobalKey<FormState>());

}


enum ReportImagesFields {
  truckLicensePlate,
  trailerLicensePlate,
  proofOfDelivery,
  cmr,
  deliverySlip,
}
