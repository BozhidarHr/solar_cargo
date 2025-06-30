import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solar_cargo/screens/common/constants.dart';

import '../../models/checkbox_comment.dart';

class Step3ChecklistItem extends StatelessWidget {
  final String label;
  final CheckBoxItem item;
  final Function(ReportOption?) onOptionChanged;
  final VoidCallback? onAddComment;
  final ValueChanged<String>? onCommentChanged;
  final VoidCallback? onRemoveComment;

  const Step3ChecklistItem({
    super.key,
    required this.label,
    required this.item,
    required this.onOptionChanged,
    this.onAddComment,
    this.onCommentChanged,
    this.onRemoveComment,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle =
    Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white);

    Widget buildCheckbox(String title, ReportOption option, ReportOption? selectedOption, void Function(ReportOption?) onChanged) {
      return InkWell(
        onTap: () {
          if (selectedOption == option) {
            onChanged(null);
          } else {
            onChanged(option);
          }
        },
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
              onChanged: (value) =>
                  onChanged(value == true ? option : null),
            ),
            Text(title, style: textStyle),
            const SizedBox(width: 10),
          ],
        ),
      );
    }

    return FormField<ReportOption>(
      initialValue: item.selectedOption,
      validator: (selectedOption) {
        if (selectedOption == null) {
          return 'Please select an option.';
        }
        return null;
      },
      builder: (field) {
        void onChanged(ReportOption? newOption) {
          field.didChange(newOption); // update FormField internal state
          onOptionChanged(newOption); // notify external listener
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: textStyle),
            Row(
              children: [
                buildCheckbox('OK', ReportOption.ok, field.value, onChanged),
                buildCheckbox('Not OK', ReportOption.notOk, field.value, onChanged),
                buildCheckbox('N/A', ReportOption.na, field.value, onChanged),
                const Spacer(),
                ElevatedButton(
                  onPressed: onAddComment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    backgroundColor: kFormFieldBackgroundColor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(children: [
                    const Icon(Icons.add, color: Colors.black, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      'comment',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ]),
                ),
              ],
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  field.errorText ?? '',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 8),
            if (item.comment != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: item.comment,
                      onChanged: onCommentChanged,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Add a comment',
                        fillColor: kFormFieldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(8),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        errorStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                      validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Please enter comment.'
                          : null,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(8),
                      ),
                    ),
                    child: Container(
                      height: 52, // match TextFormField height + padding
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(8),
                        ),
                      ),
                      child: IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        onPressed: onRemoveComment,
                        icon: SvgPicture.asset(kDeleteSvg),
                        splashRadius: 22,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
