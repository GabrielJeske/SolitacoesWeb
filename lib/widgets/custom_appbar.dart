import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TabController? controller;

  const CustomAppBar({
    super.key,
    required this.title,
    this.controller,
  });  
  
  @override
  Widget build(BuildContext context) {
    
    return  AppBar(
      title: Text(
        title,
        style: TextStyle(          
          fontSize: 26.0,
          fontWeight: FontWeight.w400,
          height: 1.40,
          letterSpacing: 0.06,  
        ),
      ),           
    );
  }
  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}