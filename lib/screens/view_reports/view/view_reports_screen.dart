import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';
import 'package:solar_cargo/screens/view_reports/viewmodel/view_reports_view_model.dart';

import '../../../services/api_response.dart';
import '../../common/constants.dart';
import '../../common/loading_widget.dart';
import '../model/delivery_report.dart';

class ViewReportsScreen extends StatefulWidget {
  const ViewReportsScreen({super.key});

  @override
  State<ViewReportsScreen> createState() => _ViewReportsScreenState();
}

class _ViewReportsScreenState extends State<ViewReportsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ViewReportsViewModel>(context, listen: false)
          .fetchDeliveryReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Reports'),
        backgroundColor: HexColor(kPrimaryGreenColor),
        foregroundColor: Colors.white,
      ),
      body: Selector<ViewReportsViewModel, ApiResponse<dynamic>>(
        selector: (_, viewModel) => viewModel.fetchReportsResponse,
        builder: (context, response, child) {
          switch (response.status) {
            case Status.LOADING:
              return const LoadingWidget();
            case Status.COMPLETED:
              return _buildBody(response.data);
            case Status.ERROR:
            default:
              return const LoadingWidget();
          }
        },
      ),
    );
  }

  ListView _buildBody(List<DeliveryReport> reports) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: HexColor(kPrimaryGreenColor).withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Navigate to detail screen if needed
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location: ${report.location}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: HexColor(kPrimaryGreenColor),
                  ),
                ),
                const SizedBox(height: 8),
                if (report.supplier.isNotNullAndNotEmpty)
                  _buildDetailRow('Supplier', report.supplier!),
                if (report.deliverySlipNumber.isNotNullAndNotEmpty)
                  _buildDetailRow('Delivery Slip #', report.deliverySlipNumber!),
                if (report.logisticCompany.isNotNullAndNotEmpty)
                  _buildDetailRow('Logistics', report.logisticCompany!),
                if (report.licencePlateTruck.isNotNullAndNotEmpty)
                  _buildDetailRow('Truck', report.licencePlateTruck!),
                if (report.weatherConditions.isNotNullAndNotEmpty)
                  _buildDetailRow('Weather', report.weatherConditions!),
                if (report.comments.isNotNullAndNotEmpty)
                  _buildDetailRow('Comments', report.comments!),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.chevron_right, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$title: $value',
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}