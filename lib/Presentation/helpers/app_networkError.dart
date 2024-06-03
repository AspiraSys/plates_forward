// ignore: file_names
import 'package:flutter/material.dart';

class NoDataMessage extends StatelessWidget {
  final String message;

  const NoDataMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => {},
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
