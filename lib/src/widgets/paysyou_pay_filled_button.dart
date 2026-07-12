import 'package:flutter/material.dart';

import '../theme/paysyou_pay_theme.dart';
import 'paysyou_pay_logo.dart';

/// Gradient filled pay button with animated glow.
class PaysYouPayFilledButton extends StatefulWidget {
  const PaysYouPayFilledButton({
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
  State<PaysYouPayFilledButton> createState() => _PaysYouPayFilledButtonState();
}

class _PaysYouPayFilledButtonState extends State<PaysYouPayFilledButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = PaysYouPayTheme.gradientFor(theme.brightness);
    final radius = BorderRadius.circular(widget.borderRadius);

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          height: PaysYouPayTheme.buttonHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: gradient,
            boxShadow: [
              BoxShadow(
                color: PaysYouPayTheme.primary
                    .withValues(alpha: _glowAnimation.value),
                blurRadius: 22,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: PaysYouPayTheme.secondary
                    .withValues(alpha: _glowAnimation.value * 0.5),
                blurRadius: 32,
                spreadRadius: 1,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          borderRadius: radius,
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.03),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                top: 1,
                left: 1,
                right: 1,
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.65),
                        Colors.white.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (widget.isLoading) {
      return widget.loadingWidget ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Processing...',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
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
            child: Text(
              widget.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
            ),
          ),
          Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white.withValues(alpha: 0.95),
            size: 20,
          ),
        ],
      ),
    );
  }
}
