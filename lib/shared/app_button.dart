import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height = 50,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double height;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    final button = SizedBox(
      height: height,
      child: FilledButton(
        onPressed: isDisabled ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF42A5F5),
          disabledBackgroundColor: const Color(0xFF42A5F5).withValues(
            alpha: 0.55,
          ),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );

    if (expand) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}