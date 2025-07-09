import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/flash_helper.dart';
import '../../create_report/view/report_steps/create_report_step1.dart';
import '../../create_report/view/report_steps/create_report_step3.dart';
import '../../create_report/view/report_steps/create_report_step4.dart';
import '../../create_report/viewmodel/create_report_view_model.dart';

class ViewReportDetail extends StatefulWidget {
  ViewReportDetail({
    super.key,
  });

  @override
  State<ViewReportDetail> createState() => _ViewReportDetailState();
}

class _ViewReportDetailState extends State<ViewReportDetail> {
  final List<GlobalKey<FormState>> formKeys =
      List.generate(4, (_) => GlobalKey<FormState>());

  late final CreateReportViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<CreateReportViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    const divider = Divider(
      color: Colors.white,
      indent: 20,
      endIndent: 20,
      thickness: 1.5,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Delivery Report'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 90),
            // Reserve space for buttons
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Step1Form(
                    formKey: formKeys[0],
                    viewModel: viewModel,
                  ),
                  divider,
                  Step3Form(
                    formKey: formKeys[1],
                    viewModel: viewModel,
                    restrictBack: true,
                  ),
                  divider,
                  Step3Form(
                    formKey: formKeys[2],
                    viewModel: viewModel,
                    restrictBack: true,
                  ),
                  divider,
                  Step4Form(
                    formKey: formKeys[3],
                    viewModel: viewModel,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: Theme.of(context).textTheme.titleMedium,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: Navigator.of(context).pop,
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: Theme.of(context).textTheme.titleMedium,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (_allValid(context)) {
                          // execute request
                          // onSubmit();
                          //  after logic
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _allValid(BuildContext context) {
    // Validate forms
    final allFormsValid =
        formKeys.every((key) => key.currentState?.validate() ?? false);

    // Validate images using the same logic as in each step
    final step1ImagesValid =
        viewModel.newReport.truckLicencePlateImage != null &&
            viewModel.newReport.trailerLicencePlateImage != null;
    final step2ImagesValid = viewModel.newReport.proofOfDelivery != null;
    final step4ImagesValid = viewModel.newReport.cmrImage != null &&
        viewModel.newReport.deliverySlipImage != null;

    if (!allFormsValid) {
      FlashHelper.errorMessage(context,
          message: 'Please complete all required fields.');
      return false;
    }
    if (!step1ImagesValid) {
      FlashHelper.errorMessage(context,
          message: 'Please add license plate images.');
      return false;
    }
    if (!step2ImagesValid) {
      FlashHelper.errorMessage(context,
          message: 'Please add proof of delivery image.');
      return false;
    }
    if (!step4ImagesValid) {
      FlashHelper.errorMessage(context,
          message: 'Please add CMR/Delivery Slip images.');
      return false;
    }
    return true;
  }
}
