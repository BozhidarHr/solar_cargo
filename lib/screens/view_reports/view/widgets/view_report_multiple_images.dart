import 'package:flutter/material.dart';

import '../../../common/base64Image.dart';

class ViewReportMultipleImages extends StatelessWidget {
  final List? images;
  final String label;

  const ViewReportMultipleImages({
    super.key,
    required this.images,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (images?.isEmpty ?? true) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
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
              itemCount: images!.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Base64ImageWidget(
                  base64String: images![index].content,
                  width: 220,
                  height: 210,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
