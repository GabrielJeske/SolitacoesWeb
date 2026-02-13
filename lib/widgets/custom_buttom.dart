 
import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed; 

  const CustomButtom({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(      
      onPressed: onPressed,
      // style: ElevatedButton.styleFrom(
      //   fixedSize: Size.fromHeight(48),
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(8)
      //         ),
      //         padding:EdgeInsets.all(10),
      //         backgroundColor: Theme.of(context).colorScheme.primary,
      //         foregroundColor: Theme.of(context).colorScheme.onPrimary,
      //         textStyle: TextStyle(fontSize: 14)
      // ),

     child: Text(
        label?.toUpperCase() ?? '', // Texto em caixa alta fica mais moderno
        style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
      
    );
  }
}