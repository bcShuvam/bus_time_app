import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.widget,
    this.backgroundColor,
    this.borderColor,
  });

  final Function() onPressed;
  final Widget widget;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0.0,
        minimumSize: Size(
          MediaQuery.of(context).size.width * 0.25,
          40,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        side: BorderSide(
          color: borderColor ?? Colors.transparent,
          style: BorderStyle.solid,
        ),
      ),
      child: widget,
    );
  }
}
