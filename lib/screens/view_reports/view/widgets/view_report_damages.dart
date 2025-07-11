import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';
import 'package:solar_cargo/screens/view_reports/model/delivery_report.dart';
import 'package:solar_cargo/screens/view_reports/view/widgets/view_report_multiple_images.dart';

class ViewReportDamages extends StatefulWidget {
  final DeliveryReport report;

  const ViewReportDamages({super.key, required this.report});

  @override
  State<ViewReportDamages> createState() => _ViewReportDamagesState();
}

class _ViewReportDamagesState extends State<ViewReportDamages> {
  final ScrollController _descriptionController = ScrollController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.report.damagesDescription.isEmptyOrNull &&
        (widget.report.damagesImages?.isEmpty ?? true)) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          children: [
            Text(
              'Damages',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).secondaryHeaderColor,
                fontWeight: FontWeight.w700,
                fontSize: 15,
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
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Damages description:',
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
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 150,
                          ),
                          child: Scrollbar(
                            controller: _descriptionController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _descriptionController,
                              child: Text(
                                widget.report.damagesDescription ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ViewReportMultipleImages(
                images: widget.report.damagesImages, label: 'Damages images'),
          ],
        ),
      ),
    );
  }
}
