import 'package:flutter/material.dart';
import '../utils/l10n_extension.dart';
import 'package:lottie/lottie.dart';
import '../utils/lottie_assets.dart';

/// **ErrorRetry**
/// A fully responsive, reusable error state widget following industry-standard UX patterns.
///
/// Usage:
/// ```dart
/// ErrorRetry(
///   message: 'City not found',
///   onRetry: () => cubit.getForecastForCity('London'),
/// )
/// ```
///
/// Design:
/// - Uses `LayoutBuilder` + `MediaQuery` to adapt layout for phone, tablet, and desktop breakpoints.
/// - Lottie animation shrinks on smaller screens so the CTA button remains above the fold.
/// - The retry button uses the theme's `primaryColor` so it automatically respects light/dark mode.
class ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  /// Optional label for the retry button. Defaults to localized 'Try Again'.
  final String? retryLabel;

  const ErrorRetry({
    super.key,
    required this.message,
    required this.onRetry,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // --- Responsive breakpoints ---
        // Phone  : < 600
        // Tablet : 600 – 1024
        // Desktop: > 1024
        final isTabletOrLarger = width >= 600;
        final lottieSize = isTabletOrLarger ? 280.0 : 180.0;
        final messageFontSize = isTabletOrLarger ? 20.0 : 16.0;
        final buttonWidth = isTabletOrLarger ? 240.0 : double.infinity;
        final horizontalPadding = isTabletOrLarger ? width * 0.2 : 32.0;

        return Center(
          child: SingleChildScrollView(
            // Keeps the widget scrollable if the screen is very short (landscape phone)
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- Lottie Animation ---
                  Lottie.asset(
                    LottieAsset.showSearchWaiting,
                    width: lottieSize,
                    height: lottieSize,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 24),

                  // --- Error Message ---
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: messageFontSize,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.error,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- Retry Button ---
                  // Constrained width on larger screens, full-width on phone.
                  SizedBox(
                    width: buttonWidth,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(
                        retryLabel ?? context.l10n.tryAgain,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
