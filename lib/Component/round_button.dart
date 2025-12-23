import 'package:ai_resume_scanner/constant/my_colors.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;

  const RoundButton({
    super.key,
    required this.title,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onPress,
      child: Container(
        height: screenWidth * 0.13, // responsive height
        width: screenWidth * 0.7,   // responsive width
        constraints: const BoxConstraints(
          minHeight: 45,
          maxHeight: 60,
          maxWidth: 400, // looks good on tablets/web
        ),
        decoration: BoxDecoration(
          color: myColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: buttonStyle,
          ),
        ),
      ),
    );
  }
}
