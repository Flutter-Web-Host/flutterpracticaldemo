// Category Button Widget
import 'package:flutter/material.dart';
import 'package:flutter_practicle/infrastructure/constants/color_constant.dart';

class CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const CategoryButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? ColorConstant.blueDarkColor
              : ColorConstant.blueLightColor,
        ),
        child: Text(label),
      ),
    );
  }
}
