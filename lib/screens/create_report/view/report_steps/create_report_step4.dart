import 'package:flutter/material.dart';

class Step4Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const Step4Form({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('CMR'),
          trailing:
              ElevatedButton(onPressed: () {}, child: const Text('Browse')),
        ),
        ListTile(
          title: const Text('Delivery Slip'),
          trailing:
              ElevatedButton(onPressed: () {}, child: const Text('Browse')),
        ),
        ListTile(
          title: const Text('Other (multiple) (optional)'),
          trailing:
              ElevatedButton(onPressed: () {}, child: const Text('Browse')),
        ),
      ],
    );
  }
}
