import 'package:flutter/material.dart';

class RefreshesIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const RefreshesIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: child,
    );
  }
}
