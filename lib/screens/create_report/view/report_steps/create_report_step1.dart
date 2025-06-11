
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../../common/constants.dart';
import '../../viewmodel/create_report_view_model.dart';
import '../widgets/create_report_controllers_mixin.dart';
import '../../../common/image_selection_field.dart';

class Step1Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Map<Step1TextFields, TextEditingController> controllers;

  const Step1Form({
    super.key,
    required this.formKey,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    final createReportViewModel =
        Provider.of<CreateReportViewModel>(context, listen: false);
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                S.of(context).step1Title,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.white),
              ),
              ..._buildFields(context),
              const SizedBox(height: 12),
              ImageSelectionField(
                  label: S.of(context).truckLicensePlate,
                  initialImage: createReportViewModel.images[ReportImagesFields.truckLicensePlate],
                  onImageSelected: (file) {
                    createReportViewModel.images[ReportImagesFields.truckLicensePlate] = file;
                  }),
              const SizedBox(height: 12),
              ImageSelectionField(
                label: S.of(context).trailerLicensePlate,
                initialImage: createReportViewModel.images[ReportImagesFields.trailerLicensePlate],
                onImageSelected: (file) {
                  createReportViewModel.images[ReportImagesFields.trailerLicensePlate] = file;
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
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
