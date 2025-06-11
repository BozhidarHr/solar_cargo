import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/screens/common/image_selection_field.dart';

import '../../viewmodel/create_report_view_model.dart';
import '../widgets/create_report_controllers_mixin.dart';
import '../../../common/multiple_images_selection_field.dart';

class Step4Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const Step4Form({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final createReportViewModel =
        Provider.of<CreateReportViewModel>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: [
          ImageSelectionField(
            label: 'CMR',
            initialImage: createReportViewModel.images[ReportImagesFields.cmr],
            onImageSelected: (file) {
              createReportViewModel.images[ReportImagesFields.cmr] = file;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          ImageSelectionField(
            label: 'Delivery Slip',
            initialImage: createReportViewModel.images[ReportImagesFields.deliverySlip],
            onImageSelected: (file) {
              createReportViewModel.images[ReportImagesFields.deliverySlip] =
                  file;
            },
          ),const SizedBox(
            height: 12,
          ),
          MultiImageSelectionField(
            label: "Other (multiple) (optional)",
            initialImages: createReportViewModel.optionalImages,
            onImagesSelected: (images) {
              createReportViewModel.optionalImages = images;
            },
          ),
        ],
      ),
    );
  }
}
