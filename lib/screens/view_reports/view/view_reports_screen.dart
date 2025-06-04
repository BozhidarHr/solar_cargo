import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/screens/view_reports/viewmodel/view_reports_view_model.dart';

import '../../../services/api_response.dart';
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
      Provider.of<ViewReportsViewModel>(context,listen:false).fetchDeliveryReports();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Reports'),
      ),
      body: Selector<ViewReportsViewModel, ApiResponse<dynamic>>(
        selector: (_, viewModel) => viewModel.fetchReportsResponse,
        builder: (context, response, child) {
          switch (response.status) {
            case Status.LOADING:
              return const CircularProgressIndicator();
            case Status.COMPLETED:
              return _buildBody(response.data);
            case Status.ERROR:
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  ListView _buildBody(List<DeliveryReport> reports) {
    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text('Location: ${report.location}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Supplier: ${report.supplier}'),
                Text('Delivery Slip #: ${report.deliverySlipNumber}'),
                Text('Logistics: ${report.logisticCompany}'),
                Text('Truck: ${report.licencePlateTruck}'),
                Text('Weather: ${report.weatherConditions}'),
                if (report.comments != null)
                  Text('Comments: ${report.comments}'),
              ],
            ),
            isThreeLine: true,
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to detail screen if needed
            },
          ),
        );
      },
    );
  }
}
