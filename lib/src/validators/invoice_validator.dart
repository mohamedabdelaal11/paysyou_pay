import '../models/paysyou_invoice.dart';

/// Validates [PaysYouInvoice] before an API call.
///
/// Implementations may throw [PaysYouPayValidationException].
abstract interface class InvoiceValidator {
  void validate(PaysYouInvoice invoice);
}
