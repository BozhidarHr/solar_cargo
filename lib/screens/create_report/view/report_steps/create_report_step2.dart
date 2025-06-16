import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/common/image_selection_field.dart';

import '../../../common/constants.dart';
import '../../../common/flash_helper.dart';
import '../../models/delivery_item_controllers.dart';
import '../../viewmodel/create_report_view_model.dart';
import '../widgets/create_report_mixin.dart';

class Step2Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CreateReportViewModel viewModel;

  final VoidCallback? onNext;
  final VoidCallback? onBack;

  final List<DeliveryItemControllers> itemControllers;
  final VoidCallback onAddItem;
  final void Function(int index) onRemoveItem;

  const Step2Form({
    super.key,
    required this.formKey,
    required this.viewModel,
    this.onNext,
    this.onBack,
    required this.itemControllers,
    required this.onAddItem,
    required this.onRemoveItem,
  });

  bool _validate(BuildContext context) {
    final formValid = formKey.currentState?.validate() ?? false;
    final proof = viewModel.images[ReportImagesFields.proofOfDelivery];

    if (!formValid) return false;

    if (proof == null) {
      FlashHelper.errorMessage(context,
          message: 'Please add proof of delivery image.');
      return false;
    }

    return true;
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
                  'Step 2: Delivery Items',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            ...List.generate(itemControllers.length, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Item ${index + 1}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: kDeliveryItemFieldColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: TextFormField(
                            controller: itemControllers[index].nameController,
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                              hintText: 'Name',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8),
                              border: InputBorder.none,
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Item name is required'
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: kDeliveryItemFieldColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: TextFormField(
                            controller: itemControllers[index].amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Amount',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8),
                              border: InputBorder.none,
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Amount is required'
                                    : null,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: -10,
                      top: -15,
                      child: IconButton(
                        iconSize: 25,
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => onRemoveItem(index),
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onAddItem,
                child: const Text('Add another Item'),
              ),
            ),
            const SizedBox(height: 16),
            ImageSelectionField(
              label: 'Proof of delivery',
              initialImage:
                  viewModel.images[ReportImagesFields.proofOfDelivery],
              onImageSelected: (file) {
                viewModel.images[ReportImagesFields.proofOfDelivery] = file;
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                if (onBack != null)
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
                if (onNext != null)
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
                      onPressed: () => _handleNext(context, onNext!),
                      child: const Text('Next Step'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
