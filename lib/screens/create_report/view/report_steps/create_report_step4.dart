import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/common/image_selection_field.dart';

import '../../../common/flash_helper.dart';
import '../../../common/multiple_images_selection_field.dart';
import '../../viewmodel/create_report_view_model.dart';
import '../widgets/create_report_mixin.dart';

class Step4Form extends StatelessWidget {
  final CreateReportViewModel viewModel;
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const Step4Form({
    super.key,
    required this.viewModel,
    this.onNext,
    this.onBack,
  });

  bool _validate(BuildContext context) {
    final cmr = viewModel.images[ReportImagesFields.cmr];
    final slip = viewModel.images[ReportImagesFields.deliverySlip];
    if (cmr == null || slip == null) {
      FlashHelper.errorMessage(context,
          message: 'Please add CMR/Delivery Slip images.');
      return false;
    }
    return true;
  }

  void _handleSubmit(BuildContext context, VoidCallback onNext) {
    if (_validate(context)) {
      onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25),

      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Step 4: Delivery Images',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          ImageSelectionField(
            label: 'CMR',
            initialImage: viewModel.images[ReportImagesFields.cmr],
            onImageSelected: (file) {
              viewModel.images[ReportImagesFields.cmr] = file;
            },
          ),
          const SizedBox(height: 12),
          ImageSelectionField(
            label: 'Delivery Slip',
            initialImage: viewModel.images[ReportImagesFields.deliverySlip],
            onImageSelected: (file) {
              viewModel.images[ReportImagesFields.deliverySlip] = file;
            },
          ),
          const SizedBox(height: 12),
          MultiImageSelectionField(
            label: "Other (multiple) (optional)",
            initialImages: viewModel.optionalImages,
            onImagesSelected: (images) {
              viewModel.optionalImages = images;
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              if (onBack != null)
                Expanded(
                  child: ElevatedButton(
                    onPressed: onBack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Back'),
                  ),
                ),
              const SizedBox(width: 16),
              if (onNext != null)
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _handleSubmit(context, onNext!),
                    child: const Text('Preview'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
