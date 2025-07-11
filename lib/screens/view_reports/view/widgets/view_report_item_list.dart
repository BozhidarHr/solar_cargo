import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';

import '../../../common/constants.dart';
import '../../model/delivery_report.dart';

class ViewReportItemList extends StatelessWidget {
  final DeliveryReport report;

  const ViewReportItemList({
    required this.report,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          Text(
            'Items:',
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
          const SizedBox(
            height: 10,
          ),
          ...List.generate(report.deliveryItems.length, (index) {
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
          }),
        ],
      ),
    );
  }
}
