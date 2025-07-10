import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/providers/auth_provider.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';
import 'package:solar_cargo/screens/view_reports/view/view_report_detail_new.dart';

import '../../../generated/l10n.dart';
import '../../../routes/route_list.dart';
import '../../common/constants.dart';
import '../../common/loading_widget.dart';
import '../model/delivery_report.dart';
import '../viewmodel/view_reports_view_model.dart';

class ViewReportsScreen extends StatefulWidget {
  const ViewReportsScreen({super.key});

  @override
  _ViewReportsScreenState createState() => _ViewReportsScreenState();
}

class _ViewReportsScreenState extends State<ViewReportsScreen> {
  late final ScrollController _scrollController;
  late final ViewReportsViewModel viewModel;
  late final AuthProvider authModel;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      authModel = Provider.of<AuthProvider>(context, listen: false);
      viewModel = Provider.of<ViewReportsViewModel>(context, listen: false)
        ..fetchDeliveryReportsByLocation(
            locationId: authModel.currentUser?.currentLocation?.id,
            refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || viewModel.isLoadingMore) return;

    const thresholdPixels = 200;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= thresholdPixels &&
        viewModel.hasMorePages) {
      viewModel.fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Reports'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ViewReportsViewModel>(
        builder: (context, viewModel, _) {
          final reports = viewModel.allReports;
          final errorMessage = viewModel.errorMessage;

          if (viewModel.isLoading && reports.isEmpty) {
            return const LoadingWidget();
          }

          if (errorMessage != null && reports.isEmpty) {
            return Center(
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return _buildReportsList(reports, viewModel.isLoadingMore);
        },
      ),
    );
  }

  Widget _buildReportsList(List<DeliveryReport> reports, bool isLoadingMore) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: reports.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == reports.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: LoadingWidget(height: 70, width: 70)),
          );
        }
        return _ReportListItem(report: reports[index]);
      },
    );
  }
}

class _ReportListItem extends StatelessWidget {
  final DeliveryReport report;

  const _ReportListItem({required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kFormFieldBackgroundColor,
        border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.of(context).pushNamed(RouteList.reportDetails,
              arguments: ViewReportDetailArguments(report));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              report.buildHeaderText,
              maxLines: 2,
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.secondaryHeaderColor,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            if (report.supplier.isNotNullAndNotEmpty)
              _buildDetailRow(S.of(context).supplier, report.supplier!),
            if (report.logisticCompany.isNotNullAndNotEmpty)
              _buildDetailRow(
                  S.of(context).truck, report.licencePlateTruck ?? ''),
          ],
        ),
      ),
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
