import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../common/constants.dart';
import '../../../common/flash_helper.dart';
import '../../../common/image_selection_field.dart';
import '../../viewmodel/create_report_view_model.dart';
import '../widgets/create_report_mixin.dart';

class Step1Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Map<Step1TextFields, TextEditingController> controllers;
  final CreateReportViewModel viewModel;
  final VoidCallback? onNext;

  const Step1Form({
    super.key,
    required this.formKey,
    required this.controllers,
    required this.viewModel,
    this.onNext,
  });

  bool _validate(BuildContext context) {
    final valid = formKey.currentState?.validate() ?? false;
    final truck = viewModel.images[ReportImagesFields.truckLicensePlate];
    final trailer = viewModel.images[ReportImagesFields.trailerLicensePlate];
    if (truck == null || trailer == null) {
      FlashHelper.errorMessage(
        context,
        message: 'Please add license plate images.',
      );
      return false;
    }
    return valid;
  }

  void _handleNext(BuildContext context, VoidCallback onNext) {
    if (_validate(context)) {
      onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Step 1: Delivery Information',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            ..._buildFields(context),
            const SizedBox(height: 12),
            ImageSelectionField(
              label: S.of(context).truckLicensePlate,
              initialImage:
                  viewModel.images[ReportImagesFields.truckLicensePlate],
              onImageSelected: (file) {
                viewModel.images[ReportImagesFields.truckLicensePlate] = file;
              },
            ),
            const SizedBox(height: 12),
            ImageSelectionField(
              label: S.of(context).trailerLicensePlate,
              initialImage:
                  viewModel.images[ReportImagesFields.trailerLicensePlate],
              onImageSelected: (file) {
                viewModel.images[ReportImagesFields.trailerLicensePlate] =
                    file;
              },
            ),
            const SizedBox(height: 12,),
            if (onNext != null)
              SizedBox(
                width: double.infinity,
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
                  onPressed: () => _handleNext(context, onNext!),
                  child: const Text('Next Step'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFields(BuildContext context) {
    return [
      _buildFormField(
        label: S.of(context).plantLocation,
        context: context,
        controller: controllers[Step1TextFields.pvPlantLocation]!,
        maxLines: 3,
      ),
      _buildFormField(
        label: S.of(context).checkingCompany,
        context: context,
        controller: controllers[Step1TextFields.checkingCompany]!,
      ),
      _buildFormField(
        label: S.of(context).supplier,
        context: context,
        controller: controllers[Step1TextFields.supplier]!,
      ),
      _buildFormField(
        label: S.of(context).deliverySlipNumber,
        context: context,
        controller: controllers[Step1TextFields.deliverySlipNo]!,
      ),
      _buildFormField(
        label: S.of(context).logisticsCompany,
        context: context,
        controller: controllers[Step1TextFields.logisticsCompany]!,
      ),
      _buildFormField(
        label: S.of(context).containerNumber,
        context: context,
        controller: controllers[Step1TextFields.containerNo]!,
        isNumbersOnly: true,
      ),
      const SizedBox(height: 12),
      _buildFormField(
        label: S.of(context).weatherConditions,
        context: context,
        controller: controllers[Step1TextFields.weatherConditions]!,
      ),
      const SizedBox(height: 12),
    ];
  }

  Column _buildFormField({
    required String label,
    required BuildContext context,
    required TextEditingController controller,
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
          keyboardType: isNumbersOnly ? TextInputType.number : null,
          controller: controller,
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
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Please enter $label.'
              : null,
        ),
      ],
    );
  }
}
