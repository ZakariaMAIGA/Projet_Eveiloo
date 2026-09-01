import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const AppButton({super.key, required this.text, required this.onPressed, this.isPrimary = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.buttonTeal : Colors.transparent,
          foregroundColor: isPrimary ? Colors.white : AppColors.buttonTeal,
          elevation: isPrimary ? 2 : 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          side: isPrimary ? BorderSide.none : const BorderSide(color: Colors.transparent),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}