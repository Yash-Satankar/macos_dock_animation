import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final String image;
  const IconContainer({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(
        image,
        fit: BoxFit.contain,
      ),
    );
  }
}
