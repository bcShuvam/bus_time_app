import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomInputFormField extends StatelessWidget {
  CustomInputFormField({
    super.key,
    required this.textController,
    required this.labelText,
    required this.validator,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
  });
  String? labelText;
  TextEditingController textController;
  String? Function(String?) validator;
  bool readOnly;
  Function()? onTap;
  IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: textController,
      validator: validator,
      autofocus: false,
      onTap: onTap,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: labelText,
        // prefixIcon: Icon(prefixIcon ?? null),
        contentPadding: const EdgeInsets.all(8.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
