part of 'create_report_view_model.dart';

extension CreateReportViewModelExtension on CreateReportViewModel {
  void setStep1Data(
   Map step1Controllers,
  ) {
    newReport
      ..location = step1Controllers[Step1TextFields.pvPlantLocation]?.text ?? ''
      ..checkingCompany =
          step1Controllers[Step1TextFields.checkingCompany]?.text ?? ''
      ..supplier = step1Controllers[Step1TextFields.supplier]?.text ?? ''
      ..deliverySlipNumber =
          step1Controllers[Step1TextFields.deliverySlipNo]?.text ?? ''
      ..logisticCompany =
          step1Controllers[Step1TextFields.logisticsCompany]?.text ?? ''
      ..containerNumber =
          step1Controllers[Step1TextFields.containerNo]?.text ?? ''
      ..weatherConditions =
          step1Controllers[Step1TextFields.weatherConditions]?.text ?? ''
      ..truckLicencePlateImage = images[ReportImagesFields.truckLicensePlate]
      ..trailerLicencePlateImage =
          images[ReportImagesFields.trailerLicensePlate];
  }

  void setStep2Data(List<DeliveryItemControllers> items) {
    // Set items
    newReport.deliveryItems = items
        .map((controller) {
      final parsedAmount = int.tryParse(controller.amountController.text.trim());
          return DeliveryItem(
        name: controller.nameController.text,
        amount: parsedAmount,
      );}).toList();

    //   Set proof of delivery image
    newReport.proofOfDelivery = images[ReportImagesFields.proofOfDelivery];
  }

  void setStep3Data() {
    // Set checkboxes
    newReport.checkboxItems = step3CheckboxItems.values.toList();
  }

  void setStep4Data() {
    // Set images
    newReport.cmrImage = images[ReportImagesFields.cmr];
    newReport.deliverySlipImage = images[ReportImagesFields.deliverySlip];
    newReport.additionalImages = optionalImages;
  }

  void clearCheckboxesData() {
    for (var item in step3CheckboxItems.values) {
      item
        ..selectedOption = null
        ..comment = null;
    }
  }

  void clearAllImages() {
    images.clear();
    optionalImages.clear();
  }
}
