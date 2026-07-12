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
  }
}
