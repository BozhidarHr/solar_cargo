import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/common/image_selection_field.dart';

import '../../viewmodel/create_report_view_model.dart';
import '../widgets/create_report_controllers_mixin.dart';

class Step2Form extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final CreateReportViewModel viewModel;

  const Step2Form({
    super.key,
    required this.formKey,
    required this.viewModel,
  });

  @override
  State<Step2Form> createState() => _Step2FormState();
}

class _Step2FormState extends State<Step2Form> {
  List<Map<String, String>> items = [
    {'name': '', 'amount': ''},
  ];

  void _addItem() {
    setState(() {
      items.add({'name': '', 'amount': ''});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...items.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, String> item = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Item ${index + 1}'),
                  TextFormField(
                    initialValue: item['name'],
                    decoration: const InputDecoration(labelText: 'Item name'),
                    onChanged: (value) {
                      setState(() {
                        items[index]['name'] = value;
                      });
                    },
                  ),
                  TextFormField(
                    initialValue: item['amount'],
                    decoration: const InputDecoration(labelText: 'Amount'),
                    onChanged: (value) {
                      setState(() {
                        items[index]['amount'] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }),
            ElevatedButton(
              onPressed: _addItem,
              child: const Text('Add another Item'),
            ),
            const SizedBox(height: 16),
            ImageSelectionField(
              label: 'Proof of delivery',
              initialImage: widget.viewModel
                  .images[ReportImagesFields.proofOfDelivery],
              onImageSelected: (file) {
                widget.viewModel
                    .images[ReportImagesFields.proofOfDelivery] = file;
              },
            ),
          ],
        ),
      ),
    );
  }
}
