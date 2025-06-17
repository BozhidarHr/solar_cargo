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
  final List<GlobalKey<FormState>> formKeys =
      List.generate(3, (_) => GlobalKey<FormState>());

}


enum ReportImagesFields {
  truckLicensePlate,
  trailerLicensePlate,
  proofOfDelivery,
  cmr,
  deliverySlip,
}
