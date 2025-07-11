import 'package:flutter/material.dart';

import 'constants.dart';

class TypeAheadPopupItem extends StatelessWidget {
  final dynamic item;
  final Color? color;

  const TypeAheadPopupItem({required this.item, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color ?? kFormFieldBackgroundColor,
      ),
      child: ListTile(
        title: Text(item.toString()),
      ),
    );
  }
}
