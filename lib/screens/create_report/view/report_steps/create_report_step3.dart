import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/create_report_view_model.dart';
import '../widgets/checklist_item.dart';

class Step3Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CreateReportViewModel viewModel;

  const Step3Form({
    super.key,
    required this.formKey,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateReportViewModel>(
      builder: (context, viewModel, child) {
        final step3Items = viewModel.step3Items;

        return Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: step3Items.entries.map((entry) {
                final label = entry.key;
                final item = entry.value;
                return Step3ChecklistItem(
                  label: label,
                  item: item,
                  onOptionChanged: (opt) => viewModel.setOption(label, opt),
                  onAddComment: () => viewModel.setComment(label, ''),
                  onCommentChanged: (text) => viewModel.setComment(label, text),
                  onRemoveComment: () => viewModel.removeComment(label),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
