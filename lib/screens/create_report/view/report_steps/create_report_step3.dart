import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/screens/common/report_step.dart';

import '../../../common/flash_helper.dart';
import '../../../common/will_pop_scope.dart';
import '../../models/checkbox_comment.dart';
import '../../viewmodel/create_report_view_model.dart';
import '../widgets/checklist_item.dart';

class Step3Form extends StatelessWidget implements ReportStep {
  final GlobalKey<FormState> formKey;
  final CreateReportViewModel viewModel;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final bool restrictBack;

  const Step3Form({
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
          message: 'Please complete all required fields in Step 3.');
      return false;
    }

    final proof = viewModel.newReport.proofOfDelivery;
    if (proof == null) {
      FlashHelper.errorMessage(context,
          message: 'Please add proof of delivery image in Step 3.');
      return false;
    }

    return true;
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
      child: Consumer<CreateReportViewModel>(
        builder: (context, viewModel, child) {
          final List<CheckBoxItem> checkBoxItems =
              viewModel.newReport.checkboxItems;

          return Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Step 3: Delivery Checks',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  ...checkBoxItems.map((CheckBoxItem item) {
                    final label = item.label ?? item.name;

                    return Step3ChecklistItem(
                      key: ValueKey(label),
                      label: label,
                      item: item,
                      onOptionChanged: (opt) =>
                          viewModel.setOption(item.name, opt),
                      onAddComment: () => viewModel.setComment(item.name, ''),
                      onCommentChanged: (text) =>
                          viewModel.setComment(item.name, text),
                      onRemoveComment: () => viewModel.removeComment(item.name),
                    );
                  }),
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
