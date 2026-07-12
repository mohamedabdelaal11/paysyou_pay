import 'package:flutter/material.dart';

import '../exceptions/paysyou_pay_exception.dart';
import '../models/paysyou_invoice.dart';
import '../payment_service.dart';
import 'paysyou_pay_button_style.dart';
import 'paysyou_pay_filled_button.dart';
import 'paysyou_pay_outlined_button.dart';

typedef PaysYouPayButtonBuilder = Widget Function(
  BuildContext context,
  VoidCallback? onPressed,
  bool isLoading,
);

typedef PaysYouPayLoadingBuilder = Widget Function(BuildContext context);

/// Pay button that creates an invoice and opens the PaysYou app.
///
/// Use [builder] for a fully custom button, or [loadingBuilder] to override
/// only the loading indicator while keeping the built-in style.
class PaysYouPayButton extends StatefulWidget {
  const PaysYouPayButton({
    super.key,
    required this.paysYouPay,
    required this.invoice,
    this.style = PaysYouPayButtonStyle.filled,
    this.label = 'Buy with PaysYou',
    this.borderRadius = 24,
    this.onSuccess,
    this.onError,
    this.builder,
    this.loadingBuilder,
  });

  final PaymentService paysYouPay;
  final PaysYouInvoice invoice;
  final PaysYouPayButtonStyle style;
  final String label;
  final double borderRadius;
  final VoidCallback? onSuccess;
  final void Function(PaysYouPayException error)? onError;
  final PaysYouPayButtonBuilder? builder;
  final PaysYouPayLoadingBuilder? loadingBuilder;

  @override
  State<PaysYouPayButton> createState() => _PaysYouPayButtonState();
}

class _PaysYouPayButtonState extends State<PaysYouPayButton> {
  bool _isLoading = false;

  Future<void> _onPressed() async {
    if (_isLoading) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await widget.paysYouPay.pay(widget.invoice);
      await widget.paysYouPay.launchPaymentApp(result);
      widget.onSuccess?.call();
    } on PaysYouPayException catch (error) {
      widget.onError?.call(error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final onPressed = _isLoading ? null : _onPressed;
    final loadingWidget = widget.loadingBuilder?.call(context);

    if (widget.builder != null) {
      return widget.builder!(context, onPressed, _isLoading);
    }

    return switch (widget.style) {
      PaysYouPayButtonStyle.filled => PaysYouPayFilledButton(
          onPressed: onPressed,
          label: widget.label,
          borderRadius: widget.borderRadius,
          isLoading: _isLoading,
          loadingWidget: loadingWidget,
        ),
      PaysYouPayButtonStyle.outlined => PaysYouPayOutlinedButton(
          onPressed: onPressed,
          label: widget.label,
          borderRadius: widget.borderRadius,
          isLoading: _isLoading,
          loadingWidget: loadingWidget,
        ),
    };
  }
}
