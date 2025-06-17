import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/screens/create_report/view/report_steps/create_report_preview.dart';

import '../../../services/api_response.dart';
import '../../common/flash_helper.dart';
import '../../common/loading_widget.dart';
import '../viewmodel/create_report_view_model.dart';
import 'report_steps/create_report_step1.dart';
import 'report_steps/create_report_step2.dart';
import 'report_steps/create_report_step3.dart';
import 'report_steps/create_report_step4.dart';

class CreateReportStepper extends StatefulWidget {
  const CreateReportStepper({super.key});

  @override
  State<CreateReportStepper> createState() => _CreateReportStepperState();
}

class _CreateReportStepperState extends State<CreateReportStepper> {
  final List<GlobalKey<FormState>> formKeys =
      List.generate(3, (_) => GlobalKey<FormState>());

  int _currentStep = 0;
  late final CreateReportViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<CreateReportViewModel>(context, listen: false);
    _viewModel.resetReportData();
  }

  void _nextStep() {
    if (_currentStep < 4) setState(() => _currentStep++);
  }

  void _previousStep() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      Step1Form(
        formKey: formKeys[0],
        viewModel: _viewModel,
        onNext: _nextStep,
      ),
      Step2Form(
        formKey: formKeys[1],
        viewModel: _viewModel,
        onNext: _nextStep,
        onBack: _previousStep,
      ),
      Step3Form(
        formKey: formKeys[2],
        viewModel: _viewModel,
        onNext: _nextStep,
        onBack: _previousStep,
      ),
      Step4Form(
        viewModel: _viewModel,
        onBack: _previousStep,
        onNext: _nextStep,
      ),
      CreateReportPreview(
        viewModel: _viewModel,
        formKeys: formKeys,
        onBack: _previousStep,
        onSubmit: () async {
          _viewModel.setCheckboxData();

          await _viewModel.createDeliveryReport();
        },
      )
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Create Delivery Report'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.white,
      ),
      body: Selector<CreateReportViewModel, ApiResponse>(
        selector: (context, viewModel) => viewModel.response,
        builder: (context, response, child) {
          Widget overlay = const SizedBox.shrink(); // Default no overlay
          switch (response.status) {
            case Status.INITIAL:
              break;
            case Status.LOADING:
              overlay = const LoadingWidget();
            case Status.COMPLETED:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FlashHelper.message(context,
                    message: 'Report submitted successfully',
                    duration: const Duration(seconds: 1));
                if (mounted){
                  Navigator.of(context).pop();

                }
              });

              break;
            case Status.ERROR:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FlashHelper.errorMessage(context,
                    message: 'An error occurred submitting the report.',
                    duration: const Duration(seconds: 1));
              });
              break;
          }

          return Stack(
            children: [
              child!,
              overlay,
            ],
          );
        },
        child: steps[_currentStep],
      ),
    );
  }
}
