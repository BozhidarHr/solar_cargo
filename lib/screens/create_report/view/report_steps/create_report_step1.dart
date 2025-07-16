import 'dart:async';
import 'dart:io';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../generated/l10n.dart';
import '../../../../services/services.dart';
import '../../../common/constants.dart';
import '../../../common/flash_helper.dart';
import '../../../common/image_selection_field.dart';
import '../../../common/typeahead_popup_item.dart';
import '../../viewmodel/create_report_view_model.dart';
import '../widgets/weather_dropdown.dart';

class Step1Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CreateReportViewModel viewModel;
  final VoidCallback? onNext;

  const Step1Form({
    super.key,
    required this.formKey,
    required this.viewModel,
    this.onNext,
  });

  bool _validate(BuildContext context) {
    final valid = formKey.currentState?.validate() ?? false;
    final truck = viewModel.newReport.truckLicencePlateImage;
    final trailer = viewModel.newReport.trailerLicencePlateImage;
    if (truck == null || trailer == null) {
      FlashHelper.errorMessage(
        context,
        message: 'Please add license plate images.',
      );
      return false;
    }
    return valid;
  }

  void _handleNext({
    required BuildContext context,
    required VoidCallback onNext,
    File? truckImage,
    File? trailerImage,
  }) {
    if (_validate(context)) {
      viewModel.recognisePlate(truckImage, trailerImage);
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
                  'Step 1: Delivery Information',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            ..._buildFields(context),
            const SizedBox(height: 12),
            ImageSelectionField(
              label: S.of(context).truckLicensePlate,
              initialImage: viewModel.newReport.truckLicencePlateImage,
              onImageSelected: (file) {
                viewModel.newReport.truckLicencePlateImage = file;
              },
            ),
            const SizedBox(height: 12),
            ImageSelectionField(
              label: S.of(context).trailerLicensePlate,
              initialImage: viewModel.newReport.trailerLicencePlateImage,
              onImageSelected: (file) {
                viewModel.newReport.trailerLicencePlateImage = file;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            if (onNext != null)
              SizedBox(
                width: double.infinity,
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
                  onPressed: () => _handleNext(
                    context: context,
                    onNext: onNext!,
                    truckImage: viewModel.newReport.truckLicencePlateImage,
                    trailerImage: viewModel.newReport.trailerLicencePlateImage,
                  ),
                  child: const Text('Next Step'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFields(BuildContext context) {
    return [
      _buildFormField(
          label: S.of(context).pvProject,
          context: context,
          initialValue: viewModel.newReport.pvProject?.name,
          onChanged: (val) {},
          isReadOnly: true),
      // Should be hardcoded to S&G Solar
      _buildFormField(
          label: S.of(context).subcontractor,
          context: context,
          initialValue: viewModel.newReport.subcontractor,
          onChanged: (value) {},
          isReadOnly: true),
      _buildSupplierDropdown(),
      _buildFormField(
        label: S.of(context).deliverySlipNumber,
        context: context,
        initialValue: viewModel.newReport.deliverySlipNumber,
        onChanged: (val) => viewModel.newReport.deliverySlipNumber = val,
      ),
      _buildFormField(
        label: S.of(context).logisticsCompany,
        context: context,
        initialValue: viewModel.newReport.logisticCompany,
        onChanged: (val) => viewModel.newReport.logisticCompany = val,
      ),
      _buildFormField(
        label: S.of(context).containerNumber,
        context: context,
        initialValue: viewModel.newReport.containerNumber,
        onChanged: (val) => viewModel.newReport.containerNumber = val,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: WeatherDropdown(
          viewModel: viewModel,
        ),
      ),
    ];
  }

  StatefulBuilder _buildSupplierDropdown() {
    return StatefulBuilder(builder: (context, setState) {
      Map<String, Completer<List<String>>> debouncedResults = {};

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0, left: 5, top: 15),
            child: Text(
              S.of(context).supplier,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
          TypeAheadFormField<String>(
            textFieldConfiguration: TextFieldConfiguration(
              controller:
                  TextEditingController(text: viewModel.newReport.supplier),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: kFormFieldBackgroundColor,
                  hintText: 'Enter ${S.of(context).supplier.toLowerCase()}...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  )),
              onChanged: (val) {
                viewModel.newReport.supplier = val;
              },
            ),
            suggestionsCallback: (pattern) async {
              if (pattern.length < 2) return [];

              const debounceKey = 'item-name-debounce-supplier';

              // Cancel any previous completer for this key
              if (debouncedResults[debounceKey]?.isCompleted == false) {
                debouncedResults[debounceKey]?.complete([]);
              }

              final completer = Completer<List<String>>();
              debouncedResults[debounceKey] = completer;

              EasyDebounce.debounce(
                debounceKey,
                const Duration(milliseconds: 100),
                () async {
                  if (viewModel.newReport.pvProject?.id == null) {
                    return;
                  }
                  final results = await Services().api.searchSuppliers(
                          viewModel.newReport.pvProject!.id, pattern) ??
                      [];
                  if (!completer.isCompleted) {
                    completer.complete(results);
                  }
                },
              );

              return completer.future;
            },
            itemBuilder: (context, String suggestion) {
              return TypeAheadPopupItem(item: suggestion);
            },
            onSuggestionSelected: (String suggestion) {
              final trimmed = suggestion.trim();
              if (trimmed.isNotEmpty) {
                setState(() => viewModel.newReport.supplier = trimmed);
              }
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Item name is required';
              }
              return null;
            },
            hideOnLoading: true,
            hideOnEmpty: true,
            hideOnError: true,
            loadingBuilder: (context) => const Text('Loading...'),
            errorBuilder: (context, error) => const Text('Error!'),
            noItemsFoundBuilder: (context) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No items found'),
            ),
          ),
        ],
      );
    });
  }

  Column _buildFormField({
    required String label,
    required BuildContext context,
    required String? initialValue,
    required ValueChanged<String> onChanged,
    int maxLines = 1,
    bool isReadOnly = false,
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
          readOnly: isReadOnly,
          initialValue: initialValue,
          decoration: InputDecoration(
            hintText: 'Enter ${label.toLowerCase()}...',
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
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
          maxLines: maxLines,
          onChanged: (val) {
            EasyDebounce.debounce(
              '$label-debounce',
              const Duration(seconds: 1),
              () => onChanged(val),
            );
          },
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Please enter $label.'
              : null,
        ),
      ],
    );
  }
}
