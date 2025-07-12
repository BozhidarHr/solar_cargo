import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/screens/create_report/view/report_steps/create_report_damages.dart';
import 'package:solar_cargo/screens/create_report/view/report_steps/create_report_preview.dart';

import '../../../providers/auth_provider.dart';
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
      List.generate(4, (_) => GlobalKey<FormState>());

  int _currentStep = 0;
  late final CreateReportViewModel _viewModel;
  late final AuthProvider authModel;

  @override
  void initState() {
    super.initState();
    authModel = Provider.of<AuthProvider>(context, listen: false);
    _viewModel = Provider.of<CreateReportViewModel>(context, listen: false);
    // Reset report data
    _viewModel.resetReportData();
    // Assign default field pv project
    _viewModel.newReport.pvProject = authModel.currentUser!.currentLocation!;
  }

  void _nextStep() {
    if (_currentStep < 5) setState(() => _currentStep++);
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
      CreateReportDamages(
        viewModel: _viewModel,
        onNext: _nextStep,
        onBack: _previousStep,
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
        formKey: formKeys[3],
        viewModel: _viewModel,
        onBack: _previousStep,
        onNext: _nextStep,
      ),
      CreateReportPreview(
        viewModel: _viewModel,
        formKeys: formKeys,
        onBack: _previousStep,
      ),
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
              overlay = const LoadingWidget(
                showTint: true,
                text: "This may take some time.\nPlease wait.",
              );
            case Status.COMPLETED:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FlashHelper.message(context,
                    message: 'Report submitted successfully',
                    duration: const Duration(milliseconds: 500));
                if (mounted) {
                  Navigator.of(context).pop();
                }
              });

              break;
            case Status.ERROR:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FlashHelper.errorMessage(context,
                    message: response.message ??
                        'An error occurred while submitting the report.',
                    // 'An error occurred submitting the report.',
                    duration: const Duration(milliseconds: 500));
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
        child: SafeArea(
          bottom: true,
          child: steps[_currentStep],
        ),
      ),
    );
  }
}
