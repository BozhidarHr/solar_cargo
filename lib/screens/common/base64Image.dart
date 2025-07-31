import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Base64ImageWidget extends StatelessWidget {
  final String base64String;
  final double? width;
  final double? height;

  const Base64ImageWidget({
    super.key,
    required this.base64String,
    this.width = 220,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List imageBytes = base64Decode(base64String);

    return Image.memory(imageBytes,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
              width: 220,
              height: 150,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ));
  }
}
