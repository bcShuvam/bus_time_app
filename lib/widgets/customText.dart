import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  CustomText({
    required this.text,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.size = 16.0,
    super.key,
  });

  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: size,
        color: color,
      ),
    );
  }
}
