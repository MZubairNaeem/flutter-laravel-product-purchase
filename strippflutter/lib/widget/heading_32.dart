import 'package:flutter/material.dart';

import '../home/colors.dart';

class Heading extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  const Heading({Key? key,required this.text, required this.fontWeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontWeight: fontWeight,
            fontSize: 32,
            color: AppColors().lightText),
      ),
    );
  }
}
