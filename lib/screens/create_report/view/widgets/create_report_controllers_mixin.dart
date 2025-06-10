import 'package:flutter/cupertino.dart';

enum Step1Field {
  pvPlantLocation,
  checkingCompany,
  supplier,
  deliverySlipNo,
  logisticsCompany,
  containerNo,
  weatherConditions,
}

mixin CreateReportControllersMixin {
  final Map<Step1Field, TextEditingController> step1Controllers = {
    for (var field in Step1Field.values) field: TextEditingController(),
  };

  final List<GlobalKey<FormState>> formKeys =
  List.generate(4, (_) => GlobalKey<FormState>());
}