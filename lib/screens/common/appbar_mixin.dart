import 'package:flutter/material.dart';

mixin AppBarMixin<T extends StatefulWidget> on State<T> {
  final ValueNotifier<bool> _isAtTopNotifier = ValueNotifier(true);

  ValueNotifier<bool> get isAtTopNotifier => _isAtTopNotifier;

  ScrollController? screenScrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenScrollController ??= PrimaryScrollController.of(context);
      screenScrollController?.addListener(_scrollListener);
    });
  }

  @override
  void dispose() {
    screenScrollController?.removeListener(_scrollListener);
    screenScrollController = null;
    super.dispose();
  }

  void _scrollListener() {
    if (screenScrollController == null ||
        !(screenScrollController?.hasClients ?? false) ||
        screenScrollController?.positions.length != 1) {
      return;
    }
    if ((screenScrollController?.offset ?? 0.0) > 0.0) {
      _isAtTopNotifier.value = false;
    } else {
      _isAtTopNotifier.value = true;
    }
  }

}
