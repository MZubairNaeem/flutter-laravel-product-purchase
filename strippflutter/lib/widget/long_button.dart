import 'package:flutter/material.dart';

import '../home/colors.dart';


class LongButton extends StatelessWidget {
  final String nameButton;
  final GestureTapCallback? onPressed;
  const LongButton({Key? key, required this.nameButton ,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: GestureDetector(
        onTap: () async {
          onPressed;
        },
        child: Container(
          width: double.maxFinite,
          height: 55,
          decoration: BoxDecoration(
              color: AppColors().secondaryColor,
              borderRadius:
              const BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: Text(
              nameButton,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors().greyText),
            ),
          ),
        ),
      ),
    );
  }
}
