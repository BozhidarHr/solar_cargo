import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:solar_cargo/screens/common/constants.dart';

class LoadingWidget extends StatelessWidget {
  final double height;
  final double width;

  const LoadingWidget({
    super.key,
    this.height = 110,
    this.width = 110,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        height: height,
        width: width,
        kLoadingLottie,
        errorBuilder: (_, __, ___) {
          return const SizedBox();
        },
      ),
    );
  }
}
