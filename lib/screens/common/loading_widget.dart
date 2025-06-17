import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:solar_cargo/screens/common/constants.dart';

class LoadingWidget extends StatelessWidget {
  final double height;
  final double width;
  final bool? showTint;

  const LoadingWidget({
    super.key,
    this.showTint = true,
    this.height = 110,
    this.width = 110,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: showTint == true ? Colors.black45 : null,
        child: Center(
      child: Lottie.asset(
        height: height,
        width: width,
        kLoadingLottie,
        errorBuilder: (_, __, ___) {
          return const SizedBox();
        },
      ),
    ));
  }
}
