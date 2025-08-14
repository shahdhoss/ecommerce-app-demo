import 'package:ecommerce_demo/pages/details.dart';
import 'package:ecommerce_demo/reusable_widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryIcons extends StatelessWidget {
  final String iconCategoryText;
  final Color iconColor;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onPressed;
  const CategoryIcons({
    super.key,
    required this.iconCategoryText,
    required this.iconColor,
    required this.backgroundColor,
    required this.icon,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: backgroundColor,
          child: IconButton(
            alignment: Alignment.center,
            iconSize: 28,
            onPressed: onPressed,
            icon: Icon(icon, color: iconColor),
          ),
        ),
        SizedBox(height: 8),
        Text(
          iconCategoryText,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
            color: Color(0xff6B8A88),
          ),
        ),
      ],
    );
  }
}
