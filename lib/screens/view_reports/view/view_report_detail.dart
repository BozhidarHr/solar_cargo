import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/screens/common/base64Image.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';
import 'package:solar_cargo/screens/view_reports/view/widgets/view_report_checkboxes.dart';
import 'package:solar_cargo/screens/view_reports/view/widgets/view_report_damages.dart';
import 'package:solar_cargo/screens/view_reports/view/widgets/view_report_item_list.dart';
import 'package:solar_cargo/screens/view_reports/view/widgets/view_report_multiple_images.dart';
import 'package:solar_cargo/screens/view_reports/viewmodel/view_reports_view_model.dart';

import '../../../generated/l10n.dart';
import '../../../services/api_response.dart';
import '../../common/constants.dart';
import '../../common/flash_helper.dart';
import '../../common/loading_widget.dart';
import '../../common/logger.dart';
import '../model/delivery_report.dart';
import '../model/delivery_report_image.dart';

class ViewReportDetailArguments {
  final DeliveryReport report;

  ViewReportDetailArguments(
    this.report,
  );
}

class ViewReportDetail extends StatefulWidget {
  final DeliveryReport report;

  const ViewReportDetail({
    required this.report,
    super.key,
  });

  @override
  State<ViewReportDetail> createState() => _ViewReportDetailState();
}

class _ViewReportDetailState extends State<ViewReportDetail> {
  final ScrollController _notesController = ScrollController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  late final ViewReportsViewModel viewModel;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<ViewReportsViewModel>(context, listen: false)
      ..resetDownloadResponse();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchAndAssignImages(report: widget.report);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ViewReportsViewModel, ApiResponse>(
      selector: (_, vm) => vm.downloadResponse,
      builder: (context, downloadResponse, child) {
        if (downloadResponse.status == Status.ERROR) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FlashHelper.errorMessage(context,
                message: "Report could not be downloaded.");
          });
          _dialogShown = false; // Reset flag on error, so user can retry
        }
        if (downloadResponse.status == Status.COMPLETED) {
          if (!_dialogShown) {
            _dialogShown = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FlashHelper.message(context,
                  message: "Report was downloaded successfully.");

              showDialog(
                context: context,
                builder: (dialogContext) {
                  final theme = Theme.of(context);
                  Color lighterColor = Color.alphaBlend(
                    Colors.white.withOpacity(0.8),
                    // Adjust opacity for lightness
                    Colors.grey,
                  );
                  return AlertDialog(
                    backgroundColor: lighterColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Row(
                      children: [
                        Icon(Icons.file_open,
                            color: theme.secondaryHeaderColor),
                        const SizedBox(width: 8),
                        Text(
                          'Open File?',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.secondaryHeaderColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    content: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 12),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.secondaryHeaderColor,
                            ),
                            children: const [
                              TextSpan(
                                text: 'You may have to ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              ),
                              TextSpan(
                                text: 'navigate to Downloads folder ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                ),
                              ),
                              TextSpan(
                                text: 'to find the file!',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    actionsPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          foregroundColor:
                              theme.secondaryHeaderColor.withOpacity(0.7),
                        ),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: theme.secondaryHeaderColor,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.secondaryHeaderColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          await _openFileWithPicker();
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  );
                },
              );
            });
          }
        } else {
          // Reset dialog flag when status is not completed, so dialog can appear again
          _dialogShown = false;
        }
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(widget.report.buildHeaderText),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Colors.white,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 15.0),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: kFormFieldBackgroundColor,
                      border: Border.all(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _buildMainBody(),
                  ),
                ),
              ),
              bottomNavigationBar: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Divider(
                        color: Colors.white,
                        height: 5,
                        indent: 15,
                        endIndent: 15,
                      ),
                    ),
                    _bottomPopupTriggerButton(context),
                  ],
                ),
              ),
            ),

            // Loading overlay on top of everything
            if (downloadResponse.status == Status.LOADING) ...[
              const ModalBarrier(
                dismissible: false,
              ),
              // Loading spinner in the center
              const Center(
                child: LoadingWidget(
                  showTint: true,
                  text: "This may take some time.\nPlease wait.",
                ),
              ),
            ]
          ],
        );
      },
    );
  }

  Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    final status = await Permission.manageExternalStorage.status;

    if (status.isGranted) return true;

    final result = await Permission.manageExternalStorage.request();

    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      // You could show a dialog before opening settings if needed
      await openAppSettings();
    }

    return false;
  }

  Widget _buildMainBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGeneralFields(context),
        ViewReportItemList(
          report: widget.report,
        ),
        ViewReportCheckboxes(
          report: widget.report,
        ),
        ViewReportDamages(
          report: widget.report,
        ),
        Selector<ViewReportsViewModel, ApiResponse>(
            selector: (_, vm) => vm.fetchImagesResponse,
            builder: (context, res, child) {
              if (res.status == Status.LOADING) {
                return const LoadingWidget(
                  showTint: true,
                  text: "Loading images...",
                );
              }
              return Column(
                children: [..._buildImageFields(context)],
              );
            }),
        ViewReportMultipleImages(
          images: widget.report.deliverySlipImages,
          label: 'Delivery slip images',
        ),
        ViewReportMultipleImages(
          images: widget.report.additionalImages,
          label: S.of(context).additionalImages,
        ),
      ],
    );
  }

  Widget _bottomPopupTriggerButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.download),
            label: const Text(
              "Download",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            onPressed: () => _showBottomSheetDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheetDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _downloadReportButton(
                    context: context, label: 'Download Excel', isPdf: false),
                const SizedBox(height: 12),
                _downloadReportButton(
                    context: context, label: "Download PDF", isPdf: true),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _downloadReportButton({
    required BuildContext context,
    required String label,
    required bool isPdf,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.download),
        onPressed: () async {
          Navigator.of(context).pop();
          await viewModel.downloadReport(
            isPdf: isPdf,
            reportId: widget.report.id,
          );
        },
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildImageFields(BuildContext context) {
    return [
      _buildImagePreview(
        context,
        S.of(context).truckLicensePlate,
        widget.report.truckLicencePlateImage,
      ),
      _buildImagePreview(
        context,
        S.of(context).trailerLicensePlate,
        widget.report.trailerLicencePlateImage,
      ),
      _buildImagePreview(
        context,
        S.of(context).proofOfDelivery,
        widget.report.proofOfDelivery,
      ),
      _buildImagePreview(
        context,
        S.of(context).cmrImage,
        widget.report.cmrImage,
      ),
    ];
  }

  Widget _buildGeneralFields(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildTextField(
            context: context,
            label: S.of(context).pvProject,
            value: widget.report.pvProject?.name),
        _buildTextField(
            context: context,
            label: S.of(context).subcontractor,
            value: widget.report.subcontractor),
        _buildTextField(
            context: context,
            label: S.of(context).supplier,
            value: widget.report.supplier),
        _buildTextField(
            context: context,
            label: S.of(context).deliverySlipNumber,
            value: widget.report.deliverySlipNumber),
        _buildTextField(
            context: context,
            label: S.of(context).logisticsCompany,
            value: widget.report.logisticCompany),
        _buildTextField(
            context: context,
            label: S.of(context).containerNumber,
            value: widget.report.containerNumber),
        _buildTextField(
            context: context,
            label: S.of(context).weatherConditions,
            value: widget.report.weatherConditions),
        _buildTextField(
            context: context,
            label: S.of(context).truckLicensePlate,
            value: widget.report.licencePlateTruck),
        _buildTextField(
            context: context,
            label: S.of(context).trailerLicensePlate,
            value: widget.report.licencePlateTrailer),
        _buildCommentsField(context),
      ]),
    );
  }

  Widget _buildCommentsField(BuildContext context) {
    if (widget.report.comments.isEmptyOrNull) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).comments,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              shadows: [
                const Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 1,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 150,
            ),
            child: Scrollbar(
              controller: _notesController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _notesController,
                child: Text(
                  widget.report.comments!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildImagePreview(
      BuildContext context, String label, DeliveryReportImage? image) {
    if (image?.content?.isEmptyOrNull ?? true) {
      return const SizedBox();
    }
    final imageWidget = Base64ImageWidget(base64String: image!.content!);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              shadows: [
                const Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 1,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: imageWidget,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required String? value,
  }) {
    if (value.isEmptyOrNull) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              shadows: [
                const Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 1,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              height: 1.4,
              fontSize: 16,
              shadows: [
                const Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openFileWithPicker() async {
    try {
      // Let the user pick a single file
      final result = await FilePicker.platform.pickFiles();

      if (result == null || result.files.single.path == null) {
        printLog('No file selected');
        return;
      }

      final filePath = result.files.single.path!;
      final extension = path.extension(filePath).toLowerCase();
      final fileType = fileTypes[extension];

      if (fileType == null) {
        throw Exception('Unsupported file type: $extension');
      }

      final openResult = await OpenFile.open(filePath, type: fileType);

      if (openResult.type != ResultType.done) {
        throw Exception('Failed to open file: ${openResult.message}');
      }
    } catch (e) {
      printLog('Failed to open file: $e');
    }
  }
}
