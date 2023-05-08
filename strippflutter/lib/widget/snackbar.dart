import 'package:flutter/material.dart';

showSnackBar(BuildContext context,String content, ) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 2),
    ),
  );
}