import 'package:flutter/material.dart';

import '../../../common/constants.dart';
import '../../../create_report/models/checkbox_comment.dart';
import '../../model/delivery_report.dart';

class ViewReportCheckboxes extends StatelessWidget {
  final DeliveryReport report;

  const ViewReportCheckboxes({
    required this.report,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: report.checkboxItems.map((CheckBoxItem item) {
        final label = item.label ?? item.name;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  shadows: [
                    const Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 1,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  buildCheckbox(
                    context,
                    'OK',
                    ReportOption.ok,
                    item.selectedOption,
                  ),
                  buildCheckbox(
                    context,
                    'Not OK',
                    ReportOption.notOk,
                    item.selectedOption,
                  ),
                  buildCheckbox(
                    context,
                    'N/A',
                    ReportOption.na,
                    item.selectedOption,
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 8),
              if (item.comment != null)
                Container(
                  decoration: BoxDecoration(
                    color: kDeliveryItemFieldColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextFormField(
                    readOnly: true,
                    initialValue: item.comment?.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    minLines: 1,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget buildCheckbox(
    BuildContext context,
    String title,
    ReportOption option,
    ReportOption? selectedOption,
  ) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            visualDensity: VisualDensity.compact,
            fillColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return Theme.of(context).primaryColor;
              }
              return Colors.white;
            }),
            checkColor: Colors.black,
            value: selectedOption == option,
            onChanged: (_) {},
          ),
          Text(title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
