import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomTextfield extends StatelessWidget {
  final String label;
  final int? maxLines;
  final TextEditingController? controller;
  final bool? obscureText;
  final bool? enabled;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextInputFormatter? mask;
  final String? errorText;
  final FocusNode? foco;


  const CustomTextfield({
    super.key,
    required this.label,
    this.maxLines,
    this.controller,
    this.onChanged,
    this.obscureText,
    this.enabled,
    this.mask,
    this.errorText,
    this.onTap,
    this.foco
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters:[
        if (mask != null) mask!,
      ],            
      enabled: enabled ?? true,
      focusNode: foco,
      obscureText: obscureText ?? false,
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        errorText: errorText,        
      ),
      maxLines: maxLines ?? 1,      
    );
  }
}