import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:solar_cargo/screens/common/constants.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';

class LoadingWidget extends StatelessWidget {
  final double height;
  final double width;
  final bool? showTint;
  final String? text;

  const LoadingWidget({
    super.key,
    this.showTint = true,
    this.height = 110,
    this.width = 110,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: showTint == true ? Colors.black45 : null,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            kLoadingLottie,
            height: height,
            width: width,
            errorBuilder: (_, __, ___) => const SizedBox(),
          ),
          if (text.isNotNullAndNotEmpty) ...[
            Text(
              text!,
              style:  const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.5,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }}
