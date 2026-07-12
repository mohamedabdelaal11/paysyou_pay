import '../models/create_invoice_result.dart';
import '../models/paysyou_invoice.dart';

/// Contract for creating a PaysYou invoice via HTTP.
abstract interface class InvoiceApi {
  Future<CreateInvoiceResult> createInvoice(PaysYouInvoice invoice);
}
