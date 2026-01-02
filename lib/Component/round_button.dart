import 'package:ai_resume_scanner/constant/my_colors.dart';
import 'package:ai_resume_scanner/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final TextStyle? textStyle;
  final Color? color;

  const RoundButton({
    super.key,
    required this.title,
    required this.onPress,
    this.textStyle,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<AuthViewModel>(builder: (context,auth,child){
      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap:auth.isLoading?null: onPress,
        child: Container(
          height: screenWidth * 0.13, // responsive height
          width: screenWidth * 0.7,   // responsive width
          constraints: const BoxConstraints(
            minHeight: 45,
            maxHeight: 60,
            maxWidth: 400, // looks good on tablets/web
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
              child:auth.isLoading?CircularProgressIndicator(color: Colors.white,): Text(
                title,
                style: textStyle,
              )
          ),
        ),
      );
    });
  }
}
