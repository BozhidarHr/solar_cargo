import 'package:flutter/cupertino.dart';

class DeliveryItemControllers {
  final TextEditingController nameController;
  final TextEditingController amountController;

  DeliveryItemControllers({
    required this.nameController,
    required this.amountController,
  });

  void dispose() {
    nameController.dispose();
    amountController.dispose();
  }
}