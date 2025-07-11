import 'package:flutter/material.dart';

class ViewReportMultipleImages extends StatelessWidget {
  final List images;
  final String label;

  const ViewReportMultipleImages({
    super.key,
    required this.images,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

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
}
