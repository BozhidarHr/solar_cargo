import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';

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

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ViewReportsViewModel>().fetchDeliveryReports();
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
    final viewModel = context.read<ViewReportsViewModel>();

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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              color: Colors.white,
              indent: 15,
              endIndent: 15,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 0, bottom: 16, left: 16, right: 16),
            child: _createNewReportButton(context: context),
          ),
        ],
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

    String headerText = '';
    if (report.location.isNotNullAndNotEmpty) {
      headerText += report.location!;
    }
    if (report.id != null && report.id! > 0) {
      headerText += ' #${report.id}';
    }

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
          // TODO: Navigate to detail screen if needed
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, headerText),
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

  Widget _buildHeader(ThemeData theme, String headerText) {
    return Row(
      children: [
        Text(
          headerText,
          style: theme.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.secondaryHeaderColor,
          ),
        ),
        const Spacer(),
        if (report.updatedAt != null)
          Text(
            report.updatedAtDate ?? '',
            style: theme.textTheme.bodyMedium,
          ),
      ],
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

Widget _createNewReportButton({
  required BuildContext context,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: () => Navigator.of(context).pushNamed(RouteList.createReport),
      label: Text(S.of(context).createNewReport),
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
