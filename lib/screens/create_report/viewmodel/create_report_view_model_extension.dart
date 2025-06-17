part of 'create_report_view_model.dart';

extension CreateReportViewModelExtension on CreateReportViewModel {

  void setStep2Data() {

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
