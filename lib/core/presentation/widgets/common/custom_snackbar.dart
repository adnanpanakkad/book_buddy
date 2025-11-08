import 'package:book_buddy/core/presentation/widgets/common/text_styles.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CustomSnackbar {
  // Static timer to track debounce time
  static Timer? _debounceTimer;
  static bool _isShowingSnackbar = false;

  static void show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    // If a snackbar is already being shown or we're in debounce period, don't show another one
    if (_isShowingSnackbar) {
      return;
    }

    _isShowingSnackbar = true;
    final screenWidth = MediaQuery.of(context).size.width;

    // Cancel any existing timer
    _debounceTimer?.cancel();

    // Show the snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth > 600 ? 600 : 20, // Smaller margin for mobile
          vertical: 50,
        ),
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 35,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: CustomTextStyle.robotoText(
                        Colors.white, 15, FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: CustomTextStyle.NunitoText(
                        Colors.white, 14, FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
        onVisible: () {
          // Start debounce timer when snackbar becomes visible
          _debounceTimer = Timer(const Duration(seconds: 3), () {
            _isShowingSnackbar = false;
          });
        },
      ),
    );
  }

  // Method to reset the debouncer state if needed
  static void reset() {
    _debounceTimer?.cancel();
    _isShowingSnackbar = false;
  }
}
