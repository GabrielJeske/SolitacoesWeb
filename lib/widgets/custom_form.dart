import 'package:flutter/material.dart';

class CustomForm extends StatelessWidget {
  final Widget child;

  const CustomForm({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),        
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: child,
        ),
      ),
    );
  }
}