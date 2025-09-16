import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/screens/common/flash_helper.dart';
import 'package:solar_cargo/screens/common/multiple_images_selection_field.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';

import '../../../common/constants.dart';
import '../../../common/report_step.dart';
import '../../../common/will_pop_scope.dart';
import '../../viewmodel/create_report_view_model.dart';

class CreateReportDamages extends StatelessWidget implements ReportStep {
  final GlobalKey<FormState> formKey;
  final CreateReportViewModel viewModel;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final bool restrictBack;

  const CreateReportDamages({
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
          message: 'Please complete all required fields in Step Damages.');
      return false;
    }
    final report = viewModel.newReport;
    if (report.includesDamages == true &&
        report.damagesDescription.isEmptyOrNull &&
        (report.damagesImages?.isEmpty ?? true)) {
      FlashHelper.errorMessage(context,
          message: "Fill in damages or uncheck the box to continue.");
      return false;
    }

    return true;
  }

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
          final report = viewModel.newReport;
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
                        'Optional step: Damages',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  // ✅ Add checkbox to toggle damage reporting
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      "I want to report damages",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: report.includesDamages ?? false,
                    onChanged: (val) {
                      viewModel.setIncludeDamages(val ?? false);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Theme.of(context).primaryColor,
                  ),

                  // ✅ Show form only if damages are to be included
                  if (report.includesDamages ?? false) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5.0,
                        left: 5,
                      ),
                      child: Text(
                        'Damages description',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      initialValue: report.damagesDescription,
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
                          const Duration(milliseconds: 500),
                          () => report.damagesDescription = val,
                        );
                      },
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? 'Please enter damages description.'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    MultiImageSelectionField(
                      label:
                          "Damages images (multiple) ($maxAdditionalImages max.)",
                      initialImages: report.damagesImages,
                      onImagesSelected: (images) {
                        report.damagesImages = images;
                      },
                    ),
                    const SizedBox(height: 24),
                  ],

                  Row(
                    children: [
                      if (onBack != null)
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
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
                            child: const Text('Next Step'),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
