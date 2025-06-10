import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/create_report/view/report_steps/create_report_step1.dart';
import 'package:solar_cargo/screens/create_report/view/report_steps/create_report_step2.dart';
import 'package:solar_cargo/screens/create_report/view/report_steps/create_report_step3.dart';
import 'package:solar_cargo/screens/create_report/view/report_steps/create_report_step4.dart';

import '../../view_reports/model/delivery_report.dart';

enum Step1Field {
  pvPlantLocation,
  checkingCompany,
  supplier,
  deliverySlipNo,
  logisticsCompany,
  containerNo,
  weatherConditions,
}

class CreateDeliveryReportScreen extends StatefulWidget {
  const CreateDeliveryReportScreen({super.key});

  @override
  State<CreateDeliveryReportScreen> createState() =>
      _CreateDeliveryReportScreenState();
}

class _CreateDeliveryReportScreenState
    extends State<CreateDeliveryReportScreen> {
  int _currentStep = 0;
  final List<GlobalKey<FormState>> _formKeys =
      List.generate(4, (_) => GlobalKey<FormState>());

  final Map<Step1Field, TextEditingController> _step1Controllers = {
    for (var field in Step1Field.values) field: TextEditingController(),
  };
  final DeliveryReport reportData = DeliveryReport();
  @override
  void dispose() {
    for (final controller in _step1Controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep == 0) {
        reportData.location = _step1Controllers[Step1Field.pvPlantLocation]!.text;
        reportData.checkingCompany = _step1Controllers[Step1Field.checkingCompany]!.text;
        reportData.supplier = _step1Controllers[Step1Field.supplier]!.text;
        reportData.deliverySlipNumber = _step1Controllers[Step1Field.deliverySlipNo]!.text;
        reportData.logisticCompany = _step1Controllers[Step1Field.logisticsCompany]!.text;
        reportData.containerNumber = _step1Controllers[Step1Field.containerNo]!.text;
        reportData.weatherConditions = _step1Controllers[Step1Field.weatherConditions]!.text;

        // You could also assign license plate images here if Step1Form exposes them
      }

      if (_currentStep < 3) {
        setState(() {
          _currentStep++;
        });
      } else {
        // Submit form
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Delivery Report - Step ${_currentStep + 1}'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: IndexedStack(
          index: _currentStep,
          children: [
            Step1Form(formKey: _formKeys[0], controllers: _step1Controllers),
            Step2Form(formKey: _formKeys[1]),
            Step3Form(formKey: _formKeys[2]),
            Step4Form(formKey: _formKeys[3]),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
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
                  onPressed: _previousStep,
                  child: const Text('Back'),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
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
                onPressed: () => _nextStep,
                child: Text(_currentStep == 3 ? 'Submit' : 'Next Step'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
