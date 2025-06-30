import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/common/image_selection_field.dart';

import '../../../../generated/l10n.dart';
import '../../../common/constants.dart';
import '../../../common/flash_helper.dart';
import '../../../common/multiple_images_selection_field.dart';
import '../../../common/will_pop_scope.dart';
import '../../viewmodel/create_report_view_model.dart';

class Step4Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final CreateReportViewModel viewModel;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final bool restrictBack;

  const Step4Form({
    super.key,
    required this.formKey,
    required this.viewModel,
    this.onNext,
    this.onBack,
    this.restrictBack = false,
  });

  bool _validate(BuildContext context) {
    final valid = formKey.currentState?.validate() ?? false;
    final cmr = viewModel.newReport.cmrImage;
    final slip = viewModel.newReport.deliverySlipImage;
    if (cmr == null || slip == null) {
      FlashHelper.errorMessage(context,
          message: 'Please add CMR/Delivery Slip images.');
      return false;
    }
    return valid;
  }

  void _handleSubmit(BuildContext context, VoidCallback onNext) {
    if (_validate(context)) {
      onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScopeWidget(
      onWillPop: restrictBack
          ? () async => null
          : () async {
              if (onBack != null) {
                onBack!();
                return false;
              }
              return true;
            },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Step 4: Delivery Plates and images',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Column(children: [
                _buildFormField(
                  label: S.of(context).truckLicensePlate,
                  context: context,
                  initialValue: viewModel.newReport.licencePlateTruck,
                  onChanged: (val) =>
                      viewModel.newReport.licencePlateTruck = val,
                ),
                _buildFormField(
                  label: S.of(context).trailerLicensePlate,
                  context: context,
                  initialValue: viewModel.newReport.licencePlateTrailer,
                  onChanged: (val) =>
                      viewModel.newReport.licencePlateTrailer = val,
                ),
              ]),
            ),
            const SizedBox(
              height: 10,
            ),
            ImageSelectionField(
              label: 'CMR',
              initialImage: viewModel.newReport.cmrImage,
              onImageSelected: (file) {
                viewModel.newReport.cmrImage = file;
              },
            ),
            const SizedBox(height: 12),
            ImageSelectionField(
              label: 'Delivery Slip',
              initialImage: viewModel.newReport.deliverySlipImage,
              onImageSelected: (file) {
                viewModel.newReport.deliverySlipImage = file;
              },
            ),
            const SizedBox(height: 12),
            MultiImageSelectionField(
              label: "Other (multiple) (optional)",
              initialImages: viewModel.newReport.additionalImages,
              onImagesSelected: (images) {
                viewModel.newReport.additionalImages = images;
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
      ),
    );
  }

  Column _buildFormField({
    required String label,
    required BuildContext context,
    required String? initialValue,
    required ValueChanged<String> onChanged,
    bool isNumbersOnly = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0, left: 5, top: 15),
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ),
        TextFormField(
          initialValue: initialValue,
          keyboardType: isNumbersOnly ? TextInputType.number : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: kFormFieldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
          maxLines: maxLines,
          onChanged: (val) {
            EasyDebounce.debounce(
              '$label-debounce',
              const Duration(seconds: 1),
              () => onChanged(val),
            );
          },
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Please enter $label.'
              : null,
        ),
      ],
    );
  }
}
