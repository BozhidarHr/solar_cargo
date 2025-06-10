import 'package:flutter/material.dart';

class Step3Form extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const Step3Form({super.key,required this.formKey});

  @override
  State<Step3Form> createState() => _Step3FormState();
}

class _Step3FormState extends State<Step3Form> {
  Map<String, String> checklist = {};
  Map<String, String> comments = {};

  final List<String> items = [
    'Load properly secured',
    'Goods according to delivery and PO',
    'Packaging sufficient and stable enough',
    'Delivery without damages',
    'Suitable machines for unloading/handling present',
    'Delivery slip scanned, uploaded and filed',
    'Inspection Report scanned, uploaded and filed',
  ];

  Widget _buildChecklistItem(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Row(
          children: [
            Radio<String>(
              value: 'Ok',
              groupValue: checklist[title],
              onChanged: (value) {
                setState(() {
                  checklist[title] = value!;
                });
              },
            ),
            const Text('Ok'),
            Radio<String>(
              value: 'Not Ok',
              groupValue: checklist[title],
              onChanged: (value) {
                setState(() {
                  checklist[title] = value!;
                });
              },
            ),
            const Text('Not Ok'),
            Radio<String>(
              value: 'N/A',
              groupValue: checklist[title],
              onChanged: (value) {
                setState(() {
                  checklist[title] = value!;
                });
              },
            ),
            const Text('N/A'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.comment),
              onPressed: () {
                _showCommentDialog(title);
              },
            ),
          ],
        ),
        if (comments.containsKey(title))
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextFormField(
              initialValue: comments[title],
              decoration: const InputDecoration(labelText: 'Comment'),
              onChanged: (value) {
                setState(() {
                  comments[title] = value;
                });
              },
            ),
          ),
      ],
    );
  }

  void _showCommentDialog(String title) {
    String tempComment = comments[title] ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add comment'),
        content: TextFormField(
          initialValue: tempComment,
          onChanged: (value) {
            tempComment = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                comments[title] = tempComment;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: items.map((item) => _buildChecklistItem(item)).toList(),
    );
  }
}
