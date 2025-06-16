import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/screens/create_report/view/report_steps/create_report_preview.dart';

import '../models/delivery_item_controllers.dart';
import '../viewmodel/create_report_view_model.dart';
import 'report_steps/create_report_step1.dart';
import 'report_steps/create_report_step2.dart';
import 'report_steps/create_report_step3.dart';
import 'report_steps/create_report_step4.dart';
import 'widgets/create_report_mixin.dart';

class CreateReportStepper extends StatefulWidget {
  const CreateReportStepper({super.key});

  @override
  State<CreateReportStepper> createState() => _CreateReportStepperState();
}

class _CreateReportStepperState extends State<CreateReportStepper>
    with CreateReportMixin {
  int _currentStep = 0;
  late final CreateReportViewModel _viewModel;

  final List<DeliveryItemControllers> _deliveryItemControllers = [];

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<CreateReportViewModel>(context, listen: false);
    _addItem(); // Initial item
  }

  void _addItem() {
    setState(() {
      _deliveryItemControllers.add(
        DeliveryItemControllers(
          nameController: TextEditingController(),
          amountController: TextEditingController(),
        ),
      );
    });
  }

  void _removeItem(int index) {
    if (_deliveryItemControllers.length <= 1) return;
    setState(() {
      _deliveryItemControllers[index].dispose();
      _deliveryItemControllers.removeAt(index);
    });
  }

  void _nextStep() {
    if (_currentStep < 4) setState(() => _currentStep++);
  }

  void _previousStep() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  @override
  void dispose() {
    // Step 1 dispose controllers
    for (final controller in step1Controllers.values) {
      controller.dispose();
    }
    // Step 2 dispose controllers
    for (final item in _deliveryItemControllers) {
      item.dispose();
    }
    // Set data dispose
    _viewModel.resetReportData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      Step1Form(
        formKey: formKeys[0],
        controllers: step1Controllers,
        viewModel: _viewModel,
        onNext: _nextStep,
      ),
      Step2Form(
        formKey: formKeys[1],
        viewModel: _viewModel,
        itemControllers: _deliveryItemControllers,
        onNext: _nextStep,
        onBack: _previousStep,
        onAddItem: _addItem,
        onRemoveItem: _removeItem,
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
        formKey: formKeys[3],
        viewModel: _viewModel,
        deliveryItemControllers: _deliveryItemControllers,
        step1Controllers: step1Controllers,
        onBack: _previousStep,
        onSubmit: () async {
          _viewModel.setFinalData(
            step1Controllers,
            _deliveryItemControllers,
          );
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
      body: steps[_currentStep],
    );
  }
}
