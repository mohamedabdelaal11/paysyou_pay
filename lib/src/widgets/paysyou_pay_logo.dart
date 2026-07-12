import 'package:flutter/material.dart';

import '../theme/paysyou_pay_theme.dart';

/// Shared PaysYou logo widget for package buttons and custom builders.
class PaysYouPayLogo extends StatelessWidget {
  const PaysYouPayLogo({
    super.key,
    this.size = 28,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(4),
  });

  final double size;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final resolvedBackgroundColor = backgroundColor ??
        (brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.96)
            : Colors.white.withValues(alpha: 0.9));

    return Container(
      width: size,
      height: size,
      padding: padding,
      decoration: BoxDecoration(
        color: resolvedBackgroundColor,
        borderRadius: BorderRadius.circular(size / 2.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(
        PaysYouPayTheme.logoAssetPath,
        package: 'paysyou_pay',
        fit: BoxFit.contain,
      ),
    );
  }
}
