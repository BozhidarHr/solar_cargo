import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/screens/common/multiple_images_selection_field.dart';

import '../../../common/constants.dart';
import '../../../common/will_pop_scope.dart';
import '../../viewmodel/create_report_view_model.dart';

class CreateReportDamages extends StatelessWidget {
  final CreateReportViewModel viewModel;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final bool restrictBack;

  const CreateReportDamages({
    super.key,
    required this.viewModel,
    this.onNext,
    this.onBack,
    this.restrictBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScopeWidget(
      onWillPop: restrictBack
          ? () async => false
          : () async {
              if (onBack != null) {
                onBack!();
                return false;
              }
              return true;
            },
      child: Consumer<CreateReportViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Optional step: Damages',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(bottom: 5.0, left: 5, top: 15),
                      child: Text(
                        'Damages description',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    TextFormField(
                      initialValue: viewModel.newReport.damagesDescription,
                      decoration: InputDecoration(
                        hintText: 'Enter damages description...',
                        hintStyle:
                        TextStyle(color: Colors.black.withOpacity(0.5)),
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
                      maxLines: 4,
                      onChanged: (val) {
                        EasyDebounce.debounce(
                          'damages-description-debounce',
                          const Duration(seconds: 1),
                              () => viewModel.newReport.damagesDescription = val,
                        );
                      },
                      validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Please enter damages description.'
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                MultiImageSelectionField(
                  label:
                      "Damages images (multiple) ($maxAdditionalImages max.)",
                  initialImages: viewModel.newReport.damagesImages,
                  onImagesSelected: (images) {
                    viewModel.newReport.damagesImages = images;
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
                          onPressed: onNext,
                          child: const Text('Next Step'),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
