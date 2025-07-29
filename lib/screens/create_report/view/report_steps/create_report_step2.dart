import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/screens/common/image_selection_field.dart';
import 'package:solar_cargo/screens/common/typeahead_popup_item.dart';
import 'package:solar_cargo/screens/common/will_pop_scope.dart';

import '../../../../services/services.dart';
import '../../../common/constants.dart';
import '../../../common/flash_helper.dart';
import '../../viewmodel/create_report_view_model.dart';

class Step2Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CreateReportViewModel viewModel;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final bool restrictBack;

  const Step2Form({
    super.key,
    required this.formKey,
    required this.viewModel,
    this.onNext,
    this.onBack,
    this.restrictBack = false,
  });

  bool _validate(BuildContext context) {
    final formValid = formKey.currentState?.validate() ?? false;
    final proof = viewModel.newReport.proofOfDelivery;

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
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  ...List.generate(viewModel.newReport.deliveryItems.length,
                      (index) {
                    final item = viewModel.newReport.deliveryItems[index];
                    return StatefulBuilder(builder: (context, setState) {
                      Map<String, Completer<List<String>>> debouncedResults =
                          {};
                      String? name = item.name;
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: kDeliveryItemFieldColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: TypeAheadFormField<String>(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      controller:
                                          TextEditingController(text: name),
                                      decoration: InputDecoration(
                                        hintText: 'Item name...',
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (val) {
                                        name = val;
                                        viewModel.updateItem(index, name: val);
                                      },
                                    ),
                                    suggestionsCallback: (pattern) async {

                                      final debounceKey =
                                          'item-name-debounce-$index';

                                      // Cancel any previous completer for this key
                                      if (debouncedResults[debounceKey]
                                              ?.isCompleted ==
                                          false) {
                                        debouncedResults[debounceKey]
                                            ?.complete([]);
                                      }

                                      final completer =
                                          Completer<List<String>>();
                                      debouncedResults[debounceKey] = completer;

                                      EasyDebounce.debounce(
                                        debounceKey,
                                        const Duration(milliseconds: 50),
                                        () async {
                                          final results = await Services()
                                                  .api
                                                  .searchItemsByLocation(
                                                      viewModel.newReport
                                                          .pvProject!.id,
                                                      pattern) ??
                                              [];
                                          if (!completer.isCompleted) {
                                            completer.complete(results);
                                          }
                                        },
                                      );

                                      return completer.future;
                                    },
                                    itemBuilder: (context, String suggestion) {
                                      return TypeAheadPopupItem(
                                          item: suggestion,
                                          color: Colors.white);
                                    },
                                    onSuggestionSelected: (String suggestion) {
                                      final trimmed = suggestion.trim();
                                      if (trimmed.isNotEmpty) {
                                        setState(() => name = trimmed);
                                        viewModel.updateItem(index,
                                            name: trimmed);
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Item name is required';
                                      }
                                      return null;
                                    },
                                    hideOnLoading: true,
                                    hideOnEmpty: true,
                                    hideOnError: true,
                                    loadingBuilder: (context) =>
                                        const Text('Loading...'),
                                    errorBuilder: (context, error) =>
                                        const Text('Error!'),
                                    noItemsFoundBuilder: (context) =>
                                        const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('No items found'),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: kDeliveryItemFieldColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: TextFormField(
                                    initialValue: item.amount?.toString() ?? '',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: const InputDecoration(
                                      hintText: 'Item amount...',
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (val) {
                                      EasyDebounce.debounce(
                                        'amount-debounce-$index',
                                        const Duration(seconds: 1),
                                        () {
                                          final parsed = int.tryParse(val);
                                          if (parsed != null) {
                                            viewModel.updateItem(index,
                                                amount: parsed);
                                          }
                                        },
                                      );
                                    },
                                    validator: (value) =>
                                        value == null || value.trim().isEmpty
                                            ? 'Amount is required'
                                            : null,
                                  ),
                                ),
                              ],
                            ),
                            if (index != 0)
                              Positioned(
                                right: 0,
                                top: -15,
                                child: IconButton(
                                  iconSize: 25,
                                  onPressed: () => viewModel.removeItem(index),
                                  icon: SvgPicture.asset(kDeleteSvg),
                                ),
                              ),
                          ],
                        ),
                      );
                    });
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
                      onPressed: viewModel.addDeliveryItem,
                      child: const Text('Add another Item'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ImageSelectionField(
                    label: 'Proof of delivery',
                    initialImage: viewModel.newReport.proofOfDelivery,
                    onImageSelected: (file) {
                      viewModel.newReport.proofOfDelivery = file;
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
        },
      ),
    );
  }
}
