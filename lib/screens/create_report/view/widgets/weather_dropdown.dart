import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../common/constants.dart';
import '../../viewmodel/create_report_view_model.dart';

class WeatherDropdown extends StatefulWidget {
  final CreateReportViewModel viewModel;

  const WeatherDropdown({super.key, required this.viewModel});

  @override
  State<WeatherDropdown> createState() => _WeatherDropdownState();
}

class _WeatherDropdownState extends State<WeatherDropdown> {
  final List<String> _weatherOptions = [
    'Sunny',
    'Fair',
    'Rain',
    'Snow',
    'Wind',
    'Other',
  ];

  String? _selectedWeather;
  String? _customWeather;

  @override
  void initState() {
    super.initState();

    final currentCondition = widget.viewModel.newReport.weatherConditions;

    if (_weatherOptions.contains(currentCondition)) {
      _selectedWeather = currentCondition;
    } else if (currentCondition != null && currentCondition.isNotEmpty) {
      // Handle custom weather
      _selectedWeather = 'Other';
      _customWeather = currentCondition;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherLabel = S.of(context).weatherConditions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0, left: 5, top: 15),
          child: Text(
            weatherLabel,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ),
        DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: InputDecoration(
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
            filled: true,
            fillColor: kFormFieldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          ),
          dropdownStyleData: const DropdownStyleData(
            decoration: BoxDecoration(
              color: kFormFieldBackgroundColor,
            ),
            offset: Offset(0, 0),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
            ),
          ),
          hint: Text(
            'Select ${weatherLabel.toLowerCase()}',
            style: const TextStyle(color: Colors.black),
          ),
          items: _weatherOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          value: _selectedWeather,
          onChanged: (value) {
            setState(() {
              _selectedWeather = value;
              if (value == 'Other') {
                _customWeather = '';
                widget.viewModel.newReport.weatherConditions = '';
              } else {
                _customWeather = null;
                widget.viewModel.newReport.weatherConditions = value!;
              }
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select ${weatherLabel.toLowerCase()}.';
            }
            if (value == 'Other' &&
                (_customWeather == null || _customWeather!.trim().isEmpty)) {
              return 'Please enter custom ${weatherLabel.toLowerCase()}.';
            }
            return null;
          },
        ),
        if (_selectedWeather == 'Other')
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              initialValue: _customWeather,
              decoration: InputDecoration(
                hintText: 'Enter ${weatherLabel.toLowerCase()}...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: kFormFieldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 1,
              onChanged: (val) {
                EasyDebounce.debounce(
                  '$weatherLabel-debounce',
                  const Duration(seconds: 1),
                  () => setState(() {
                    _customWeather = val.trim();
                    widget.viewModel.newReport.weatherConditions =
                        _customWeather!;
                  }),
                );
              },
            ),
          ),
      ],
    );
  }
}
