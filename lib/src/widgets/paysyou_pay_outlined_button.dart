import 'package:flutter/material.dart';

import '../theme/paysyou_pay_theme.dart';
import 'paysyou_pay_logo.dart';

/// Outlined pay button with gradient border and text.
class PaysYouPayOutlinedButton extends StatelessWidget {
  const PaysYouPayOutlinedButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.borderRadius,
    this.isLoading = false,
    this.loadingWidget,
  });

  final VoidCallback? onPressed;
  final String label;
  final double borderRadius;
  final bool isLoading;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final gradient = PaysYouPayTheme.gradientFor(brightness);
    final radius = BorderRadius.circular(borderRadius);

    return Container(
      height: PaysYouPayTheme.buttonHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: PaysYouPayTheme.secondary.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius - 2),
          child: Container(
            decoration: BoxDecoration(
              color: PaysYouPayTheme.outlinedSurfaceColorFor(brightness),
              borderRadius: BorderRadius.circular(borderRadius - 2),
            ),
            child: _buildContent(context, gradient),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LinearGradient gradient) {
    if (isLoading) {
      return loadingWidget ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: PaysYouPayTheme.primary,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Processing...',
                style: TextStyle(
                  color: PaysYouPayTheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          const PaysYouPayLogo(),
          const SizedBox(width: 12),
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => gradient.createShader(bounds),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
              ),
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) => gradient.createShader(bounds),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
