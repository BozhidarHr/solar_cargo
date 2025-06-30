import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';

import '../../../generated/l10n.dart';
import '../../common/constants.dart';
import '../../create_report/models/checkbox_comment.dart';
import '../model/delivery_report.dart';

class ViewReportDetailArguments {
  final DeliveryReport report;

  ViewReportDetailArguments(this.report);
}

class ViewReportDetailNew extends StatelessWidget {
  final DeliveryReport report;

  const ViewReportDetailNew({
    required this.report,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(report.buildHeaderText),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15.0),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: kFormFieldBackgroundColor,
              border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGeneralFields(context),
                ..._buildItemList(),
                ...buildCheckboxesList(context),
                ..._buildImageFields(context),
                _buildAdditionalImages(context,report.additionalImages),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildImageFields(BuildContext context) {
    return [
      _buildImagePreview(
        context,
        S.of(context).proofOfDelivery,
        report.proofOfDelivery,
      ),
      _buildImagePreview(
        context,
        S.of(context).cmrImage,
        report.cmrImage,
      ),
      _buildImagePreview(
        context,
        S.of(context).deliverySlipImage,
        report.deliverySlipImage,
      ),
    ];
  }

  Widget _buildGeneralFields(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildTextField(
            context: context,
            label: S.of(context).plantLocation,
            value: report.location),
        _buildTextField(
            context: context,
            label: S.of(context).checkingCompany,
            value: report.checkingCompany),
        _buildTextField(
            context: context,
            label: S.of(context).supplier,
            value: report.supplier),
        _buildTextField(
            context: context,
            label: S.of(context).deliverySlipNumber,
            value: report.deliverySlipNumber),
        _buildTextField(
            context: context,
            label: S.of(context).logisticsCompany,
            value: report.logisticCompany),
        _buildTextField(
            context: context,
            label: S.of(context).containerNumber,
            value: report.containerNumber),
        _buildTextField(
            context: context,
            label: S.of(context).weatherConditions,
            value: report.weatherConditions),
        _buildTextField(
            context: context,
            label: S.of(context).truckLicensePlate,
            value: report.licencePlateTruck),
        _buildTextField(
            context: context,
            label: S.of(context).trailerLicensePlate,
            value: report.licencePlateTrailer),
      ]),
    );
  }

  List<Widget> _buildItemList() {
    return List.generate(report.deliveryItems.length, (index) {
      final item = report.deliveryItems[index];
      if (item.name.isEmptyOrNull || item.amount == null) {
        return const SizedBox();
      }
      return Container(
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
                Text(item.name!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: kDeliveryItemFieldColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextFormField(
                    initialValue: item.amount!.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAdditionalImages(BuildContext context, List images) {
    if (images.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Images',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              shadows: const [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 1,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Image.network(
                  images[index],
                  width: 220,
                  height: 210,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 220,
                    height: 210,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildImagePreview(BuildContext context, String label, String? image) {
    if (image.isEmptyOrNull){
      return const SizedBox();
    }
    final imageWidget =
        Image.network(image!, width: 220, height: 150, fit: BoxFit.cover);
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

  Iterable<Widget> buildCheckboxesList(BuildContext context) {
    return report.checkboxItems.map((CheckBoxItem item) {
      final label = item.label ?? item.name;

      Widget buildCheckbox(
        String title,
        ReportOption option,
        ReportOption? selectedOption,
      ) {
        return InkWell(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                visualDensity: VisualDensity.compact,
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Theme.of(context).primaryColor;
                  }
                  return Colors.white;
                }),
                checkColor: Colors.black,
                value: selectedOption == option,
                onChanged: (_) {},
              ),
              Text(title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(width: 10),
            ],
          ),
        );
      }

      return Container(
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
                Text(label,
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
                    )),
                Row(
                  children: [
                    buildCheckbox(
                      'OK',
                      ReportOption.ok,
                      item.selectedOption,
                    ),
                    buildCheckbox(
                      'Not OK',
                      ReportOption.notOk,
                      item.selectedOption,
                    ),
                    buildCheckbox(
                      'N/A',
                      ReportOption.na,
                      item.selectedOption,
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 8),
                if (item.comment != null)
                  Container(
                    decoration: BoxDecoration(
                      color: kDeliveryItemFieldColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: TextFormField(
                      initialValue: item.comment?.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      minLines: 1,
                      maxLines: null,
                      // Makes it grow with content
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        // Reduces extra height around the input
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ],
        ),
      );
    });
  }
}
