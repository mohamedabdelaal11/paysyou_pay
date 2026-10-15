import '../exceptions/paysyou_pay_exception.dart';
import '../models/paysyou_invoice.dart';
import 'invoice_validator.dart';

/// Default validator for [PaysYouInvoice] fields.
final class PaysYouInvoiceValidator implements InvoiceValidator {
  const PaysYouInvoiceValidator();

  @override
  void validate(PaysYouInvoice invoice) {
    if (invoice.secretKey.trim().isEmpty) {
      throw const PaysYouPayValidationException('secretKey must not be empty.');
    }

    if (invoice.callbackUrl.trim().isEmpty) {
      throw const PaysYouPayValidationException(
        'callbackUrl must not be empty.',
      );
    }

    final uri = Uri.tryParse(invoice.callbackUrl);
    if (uri == null || !uri.hasScheme) {
      throw const PaysYouPayValidationException(
        'callbackUrl must be a valid URL.',
      );
    }

    if (invoice.amount.trim().isEmpty) {
      throw const PaysYouPayValidationException('amount must not be empty.');
    }

    final parsedAmount = double.tryParse(invoice.amount);
    if (parsedAmount == null || parsedAmount <= 0) {
      throw const PaysYouPayValidationException(
        'amount must be a positive number.',
      );
    }

    for (final product in invoice.products) {
      if (product.name.ar.trim().isEmpty) {
        throw const PaysYouPayValidationException(
          'product name ar must not be empty.',
        );
      }

      if (product.name.en.trim().isEmpty) {
        throw const PaysYouPayValidationException(
          'product name en must not be empty.',
        );
      }

      if (product.price <= 0) {
        throw const PaysYouPayValidationException(
          'product price must be a positive number.',
        );
      }

      if (product.quantity <= 0) {
        throw const PaysYouPayValidationException(
          'product quantity must be greater than 0.',
        );
      }
    }
  }
}
