import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/screens/common/image_selection_field.dart';

import '../../../../generated/l10n.dart';
import '../../../../services/api_response.dart';
import '../../../common/constants.dart';
import '../../../common/flash_helper.dart';
import '../../../common/loading_widget.dart';
import '../../../common/multiple_images_selection_field.dart';
import '../../../common/report_step.dart';
import '../../../common/will_pop_scope.dart';
import '../../viewmodel/create_report_view_model.dart';

class Step4Form extends StatelessWidget implements ReportStep {
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

  @override
  bool validate(BuildContext context) {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) {
      FlashHelper.errorMessage(context,
          message: 'Please complete all required fields in Step 4.');
      return false;
    }

    final cmr = viewModel.newReport.cmrImage;
    final slip = viewModel.newReport.deliverySlipImages;

    if (cmr == null || slip == null || slip.isEmpty) {
      FlashHelper.errorMessage(
        context,
        message: 'Please add CMR/Delivery Slip images in Step 4.',
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Selector(
      selector: (_, CreateReportViewModel model) =>
          model.recognisePlateResponse,
      builder: (_, ApiResponse response, __) {
        Widget overlay = const SizedBox.shrink();
        if (viewModel.recognisePlateResponse.status == Status.LOADING) {
          overlay = const LoadingWidget();
        }
        return Stack(children: [
          WillPopScopeWidget(
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
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
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
                      _buildFormField(
                          label: S.of(context).comments,
                          context: context,
                          initialValue: viewModel.newReport.comments,
                          maxLines: 4,
                          onChanged: (val) =>
                              viewModel.newReport.comments = val,
                          isValidated: false)
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
                  MultiImageSelectionField(
                    label:
                        'Delivery Slip (multiple) ($maxAdditionalImages max.)',
                    initialImages: viewModel.newReport.deliverySlipImages,
                    onImagesSelected: (images) {
                      viewModel.newReport.deliverySlipImages = images;
                    },
                  ),
                  const SizedBox(height: 12),
                  MultiImageSelectionField(
                    label: "Other (multiple) ($maxAdditionalImages max.)",
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
                              textStyle:
                                  Theme.of(context).textTheme.titleMedium,
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
                              textStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: onNext,
                            child: const Text('Preview'),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          overlay,
        ]);
      },
    );
  }

  Column _buildFormField({
    required String label,
    required BuildContext context,
    required String? initialValue,
    required ValueChanged<String> onChanged,
    bool isNumbersOnly = false,
    int maxLines = 1,
    bool isValidated = true,
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
            hintText: 'Enter ${label.toLowerCase()}...',
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
            filled: true,
            fillColor: kFormFieldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 14,
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
          validator: isValidated
              ? (value) => (value == null || value.trim().isEmpty)
                  ? 'Please enter $label.'
                  : null
              : null,
        ),
      ],
    );
  }
}
