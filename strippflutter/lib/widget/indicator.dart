import 'package:flutter/material.dart';

import '../home/colors.dart';

// ignore: must_be_immutable
class Indicator extends StatelessWidget {
  final bool isActive;

  const Indicator({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      width: isActive ? 36.0 : 14.0,
      height: 14.0,
      decoration: BoxDecoration(
          color: isActive ? AppColors().lightColor : AppColors().lightText,
          borderRadius: BorderRadius.circular(8.0)),
      duration: const Duration(milliseconds: 450),
    );
  }
}