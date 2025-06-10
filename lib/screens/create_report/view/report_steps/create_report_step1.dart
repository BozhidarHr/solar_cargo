
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../viewmodel/create_report_view_model.dart';
import '../widgets/create_report_controllers_mixin.dart';
import '../widgets/licence_plate_image_field.dart';

class Step1Form extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<Step1Field, TextEditingController> controllers;

  const Step1Form({
    super.key,
    required this.formKey,
    required this.controllers,
  });

  @override
  State<Step1Form> createState() => _Step1FormState();
}

class _Step1FormState extends State<Step1Form> {

  @override
  Widget build(BuildContext context) {
    final createReportViewModel =
        Provider.of<CreateReportViewModel>(context, listen: false);
    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Text(
            'Step 1: Delivery Information',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.white),
          ),
          ..._buildFields(context),
          const SizedBox(height: 12),
          LicencePlateImageField(
              label: 'Truck license plate',
              initialImage: createReportViewModel.trailerLicensePlateImage,
              onImageSelected: (file) {
                createReportViewModel.truckLicensePlateImage = file;
              }),
          const SizedBox(height: 12),
          LicencePlateImageField(
            label: 'Trailer license plate',
            initialImage: createReportViewModel.trailerLicensePlateImage,
            onImageSelected: (file) {
              createReportViewModel.trailerLicensePlateImage = file;
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  List<Widget> _buildFields(BuildContext context) {
    return [
      _buildFormField(
        label: 'PV Plant/ Location',
        context: context,
        controller: widget.controllers[Step1Field.pvPlantLocation]!,
        maxLines: 3,
      ),
      _buildFormField(
        label: 'Checking company',
        context: context,
        controller: widget.controllers[Step1Field.checkingCompany]!,
      ),
      _buildFormField(
        label: 'Supplier',
        context: context,
        controller: widget.controllers[Step1Field.supplier]!,
      ),
      _buildFormField(
        label: 'Delivery slip No',
        context: context,
        controller: widget.controllers[Step1Field.deliverySlipNo]!,
      ),
      _buildFormField(
        label: 'Logistics company',
        context: context,
        controller: widget.controllers[Step1Field.logisticsCompany]!,
      ),
      _buildFormField(
        label: 'Container No',
        context: context,
        controller: widget.controllers[Step1Field.containerNo]!,
        isNumbersOnly: true,
      ),
      const SizedBox(height: 12),
      _buildFormField(
        label: 'Weather conditions',
        context: context,
        controller: widget.controllers[Step1Field.weatherConditions]!,
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
