import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  final String label;

  const CustomCheckBox({
    super.key,
    required this.label,
  });  
  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  
  @override
  Widget build(BuildContext context) {
    bool check = false;
    return Checkbox(
          value: check,
          onChanged: (bool? value){
            setState(() {
              check = value!  ;
            });
          }        
        );
  }
}