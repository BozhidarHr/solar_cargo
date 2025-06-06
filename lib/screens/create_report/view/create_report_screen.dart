import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_reports/model/delivery_report.dart';
import '../viewmodel/create_report_view_model.dart';
import 'widgets/licence_plate_image_field.dart';

enum DeliveryReportField {
  location,
  checkingCompany,
  supplier,
  deliverySlipNumber,
  logisticCompany,
  containerNumber,
  licencePlateTruck,
  licencePlateTrailer,
  weatherConditions,
  comments,
}

class CreateDeliveryReportScreen extends StatefulWidget {
  const CreateDeliveryReportScreen({super.key});

  @override
  State<CreateDeliveryReportScreen> createState() =>
      _CreateDeliveryReportScreenState();
}

class _CreateDeliveryReportScreenState
    extends State<CreateDeliveryReportScreen> {
  final _formKey = GlobalKey<FormState>();

  File? _truckImage;
  File? _trailerImage;
  late final CreateReportViewModel createReportViewModel;

  // Controllers with enum keys
  final Map<DeliveryReportField, TextEditingController> _controllers = {
    for (var field in DeliveryReportField.values) field: TextEditingController(),
  };
@override
  void initState() {
    createReportViewModel = Provider.of<CreateReportViewModel>(
      context,
      listen: false,
    );
    super.initState();
  }
  @override
  void dispose() {
    // Dispose all controllers
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submit()async {
    if (_formKey.currentState!.validate()) {
      final newReport = DeliveryReport(
        location: _controllers[DeliveryReportField.location]!.text.trim(),
        checkingCompany:
        _controllers[DeliveryReportField.checkingCompany]!.text.trim(),
        supplier: _controllers[DeliveryReportField.supplier]!.text.trim(),
        deliverySlipNumber:
        _controllers[DeliveryReportField.deliverySlipNumber]!.text.trim(),
        logisticCompany:
        _controllers[DeliveryReportField.logisticCompany]!.text.trim(),
        containerNumber:
        _controllers[DeliveryReportField.containerNumber]!.text.trim(),
        licencePlateTruck:
        _controllers[DeliveryReportField.licencePlateTruck]!.text.trim(),
        licencePlateTrailer:
        _controllers[DeliveryReportField.licencePlateTrailer]!.text.trim(),
        weatherConditions:
        _controllers[DeliveryReportField.weatherConditions]!.text.trim(),
        comments: _controllers[DeliveryReportField.comments]!.text.trim(),
        truckLicencePlateFile: _truckImage,
        trailerLicencePlateFile: _trailerImage,
      );

      print(
          'Created DeliveryReport: ${newReport.location}, ${newReport.supplier}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Delivery report created')),
      );
      await createReportViewModel.createDeliveryReport();
      // Clear form
      _formKey.currentState!.reset();
      _controllers.forEach((key, controller) => controller.clear());
      setState(() {
        _truckImage = null;
        _trailerImage = null;
      });
    }
  }

  Widget _buildTextField({
    required DeliveryReportField field,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controllers[field],
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? 'Please enter $label' : null,
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Delivery Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(field: DeliveryReportField.location, label: 'Location'),
              _buildTextField(
                  field: DeliveryReportField.checkingCompany,
                  label: 'Checking Company'),
              _buildTextField(field: DeliveryReportField.supplier, label: 'Supplier'),
              _buildTextField(
                  field: DeliveryReportField.deliverySlipNumber,
                  label: 'Delivery Slip Number'),
              _buildTextField(
                  field: DeliveryReportField.logisticCompany,
                  label: 'Logistic Company'),
              _buildTextField(
                  field: DeliveryReportField.containerNumber,
                  label: 'Container Number'),
              _buildTextField(
                  field: DeliveryReportField.licencePlateTruck,
                  label: 'Licence Plate Truck'),
              _buildTextField(
                  field: DeliveryReportField.licencePlateTrailer,
                  label: 'Licence Plate Trailer'),
              _buildTextField(
                  field: DeliveryReportField.weatherConditions,
                  label: 'Weather Conditions'),
              _buildTextField(
                field: DeliveryReportField.comments,
                label: 'Comments',
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
              LicencePlateImageField(
                label: 'Truck Licence Plate Image',
                onImageSelected: (file) {
                  setState(() {
                    _truckImage = file;
                  });
                },
              ),
              const SizedBox(height: 20),
              LicencePlateImageField(
                label: 'Trailer Licence Plate Image',
                onImageSelected: (file) {
                  setState(() {
                    _trailerImage = file;
                  });
                },
              ),
              const SizedBox(height: 80), // Space above sticky button
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              minimumSize: const Size(160, 45),
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            onPressed: _submit,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Create Report',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
