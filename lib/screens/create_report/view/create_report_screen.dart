import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/screens/create_report/view/report_steps/create_report_step1.dart';
import 'package:solar_cargo/screens/create_report/view/report_steps/create_report_step2.dart';
import 'package:solar_cargo/screens/create_report/view/report_steps/create_report_step3.dart';
import 'package:solar_cargo/screens/create_report/view/report_steps/create_report_step4.dart';
import 'package:solar_cargo/screens/create_report/view/widgets/create_report_controllers_mixin.dart';

import '../../common/flash_helper.dart';
import '../viewmodel/create_report_view_model.dart';

class CreateDeliveryReportScreen extends StatefulWidget {
  const CreateDeliveryReportScreen({super.key});

  @override
  State<CreateDeliveryReportScreen> createState() =>
      _CreateDeliveryReportScreenState();
}

class _CreateDeliveryReportScreenState extends State<CreateDeliveryReportScreen>
    with CreateReportControllersMixin {
  // Start step
  int _currentStep = 0;
  late final CreateReportViewModel _viewModel;

  bool get _isLastStep => _currentStep == formKeys.length - 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<CreateReportViewModel>(context, listen: false);
    });
  }

  @override
  void dispose() {
    for (final controller in step1Controllers.values) {
      controller.dispose();
    }
    // reset report data upon exiting the screen
    _viewModel.resetReportData();

    super.dispose();
  }

  bool _validateStep() {
    // Validate form key in each step
    final valid = formKeys[_currentStep].currentState?.validate() ?? false;
    // First step additional validations
    if (_currentStep == 0) {
      var truckLicenseImage =
          _viewModel.images[ReportImagesFields.truckLicensePlate];
      final trailerLicenseImage =
          _viewModel.images[ReportImagesFields.truckLicensePlate];
      if (truckLicenseImage == null || trailerLicenseImage == null) {
        FlashHelper.errorMessage(
          message: "Please select license plate images.",
          context,
        );
        return false;
      }
    }
    // Step 4 additional validations
    if (_currentStep == 3) {
      final cmrImage = _viewModel.images[ReportImagesFields.cmr];
      final deliverySlipImage =
          _viewModel.images[ReportImagesFields.deliverySlip];
      if (cmrImage == null || deliverySlipImage == null) {
        FlashHelper.errorMessage(
          message: "Please select CMR/Delivery Slip images.",
          context,
        );
        return false;
      }
    }

    return valid;
  }

  void _nextStep() {
    // Validate step
    if (!_validateStep()) return;
    // Set data for step 1
    if (_currentStep == 0) {
      _viewModel.setStep1Data(
        step1Controllers: step1Controllers,
      );
    }

    if (!_isLastStep) {
      setState(() => _currentStep++);
    } else {
      // Submit logic here (execute api request).
    }
  }

  void _previousStep() {
    if (_currentStep > 0) setState(() => _currentStep--);
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
            Step1Form(
              formKey: formKeys[0],
              controllers: step1Controllers,
            ),
            Step2Form(formKey: formKeys[1]),
            Step3Form(formKey: formKeys[2]),
            Step4Form(formKey: formKeys[3]),
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
                onPressed: _nextStep,
                child: Text(_isLastStep ? 'Submit' : 'Next Step'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
