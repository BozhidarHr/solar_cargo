import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/common/image_selection_field.dart';

import '../../../common/multiple_images_selection_field.dart';
import '../../viewmodel/create_report_view_model.dart';
import '../widgets/create_report_controllers_mixin.dart';

class Step4Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CreateReportViewModel viewModel;

  const Step4Form({
    super.key,
    required this.formKey,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ImageSelectionField(
            label: 'CMR',
            initialImage: viewModel.images[ReportImagesFields.cmr],
            onImageSelected: (file) {
              viewModel.images[ReportImagesFields.cmr] = file;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          ImageSelectionField(
            label: 'Delivery Slip',
            initialImage: viewModel.images[ReportImagesFields.deliverySlip],
            onImageSelected: (file) {
              viewModel.images[ReportImagesFields.deliverySlip] = file;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          MultiImageSelectionField(
            label: "Other (multiple) (optional)",
            initialImages: viewModel.optionalImages,
            onImagesSelected: (images) {
              viewModel.optionalImages = images;
            },
          ),
        ],
      ),
    );
  }
}
