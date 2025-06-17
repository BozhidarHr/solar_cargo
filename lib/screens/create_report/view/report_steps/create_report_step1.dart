import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../common/constants.dart';
import '../../../common/flash_helper.dart';
import '../../../common/image_selection_field.dart';
import '../../viewmodel/create_report_view_model.dart';

class Step1Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CreateReportViewModel viewModel;
  final VoidCallback? onNext;
  const Step1Form({
    super.key,
    required this.formKey,
    required this.viewModel,
    this.onNext,
  });

  bool _validate(BuildContext context) {
    final valid = formKey.currentState?.validate() ?? false;
    final truck = viewModel.newReport.truckLicencePlateImage;
    final trailer = viewModel.newReport.trailerLicencePlateImage;
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
              viewModel.newReport.truckLicencePlateImage,
              onImageSelected: (file) {
                viewModel.newReport.truckLicencePlateImage = file;
              },
            ),
            const SizedBox(height: 12),
            ImageSelectionField(
              label: S.of(context).trailerLicensePlate,
              initialImage:
              viewModel.newReport.trailerLicencePlateImage,
              onImageSelected: (file) {
                viewModel.newReport.trailerLicencePlateImage = file;
              },
            ),
            const SizedBox(
              height: 12,
            ),
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
        initialValue: viewModel.newReport.location,
        onChanged: (val) => viewModel.newReport.location = val,
        maxLines: 3,
      ),
      _buildFormField(
        label: S.of(context).checkingCompany,
        context: context,
        initialValue: viewModel.newReport.checkingCompany,
        onChanged: (val) => viewModel.newReport.checkingCompany = val,
      ),
      _buildFormField(
        label: S.of(context).supplier,
        context: context,
        initialValue: viewModel.newReport.supplier,
        onChanged: (val) => viewModel.newReport.supplier = val,
      ),
      _buildFormField(
        label: S.of(context).deliverySlipNumber,
        context: context,
        initialValue: viewModel.newReport.deliverySlipNumber,
        onChanged: (val) => viewModel.newReport.deliverySlipNumber = val,
      ),
      _buildFormField(
        label: S.of(context).logisticsCompany,
        context: context,
        initialValue: viewModel.newReport.logisticCompany,
        onChanged: (val) => viewModel.newReport.logisticCompany = val,
      ),
      _buildFormField(
        label: S.of(context).containerNumber,
        context: context,
        initialValue: viewModel.newReport.containerNumber,
        onChanged: (val) => viewModel.newReport.containerNumber = val,
        isNumbersOnly: true,
      ),
      const SizedBox(height: 12),
      _buildFormField(
        label: S.of(context).weatherConditions,
        context: context,
        initialValue: viewModel.newReport.weatherConditions,
        onChanged: (val) => viewModel.newReport.weatherConditions = val,
      ),
      const SizedBox(height: 12),
    ];
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
