import 'package:flutter/material.dart';

import '../../models/delivery_item_controllers.dart';
import '../../viewmodel/create_report_view_model.dart';
import '../widgets/create_report_mixin.dart';
import 'create_report_step1.dart';
import 'create_report_step2.dart';
import 'create_report_step3.dart';
import 'create_report_step4.dart';

class CreateReportPreview extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CreateReportViewModel viewModel;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  // Pass these from the stepper to keep editing possible
  final Map<Step1TextFields, TextEditingController> step1Controllers;
  final List<DeliveryItemControllers> deliveryItemControllers;

  const CreateReportPreview({
    super.key,
    required this.formKey,
    required this.viewModel,
    required this.onSubmit,
    required this.onBack,
    required this.step1Controllers,
    required this.deliveryItemControllers,
  });

  @override
  Widget build(BuildContext context) {
    var divider = const Divider(
      color: Colors.white,
      indent: 20,
      endIndent: 20,
      thickness: 1.5,
    );

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 90), // space for sticky buttons
          child: SingleChildScrollView(
            child: Column(
              children: [
                Step1Form(
                  formKey: GlobalKey<FormState>(), // Use a new key for preview
                  controllers: step1Controllers,
                  viewModel: viewModel,
                ),
                divider,
                Step2Form(
                  formKey: GlobalKey<FormState>(),
                  viewModel: viewModel,
                  itemControllers: deliveryItemControllers,
                  onAddItem: () {},
                  onRemoveItem: (_) {},
                ),
                divider,
                Step3Form(
                  formKey: GlobalKey<FormState>(),
                  viewModel: viewModel,
                ),
                divider,
                Step4Form(
                  viewModel: viewModel,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: onBack,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
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
                    onPressed: onSubmit,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
