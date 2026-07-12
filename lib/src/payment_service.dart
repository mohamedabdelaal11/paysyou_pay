import 'models/create_invoice_result.dart';
import 'models/paysyou_invoice.dart';

/// High-level payment operations exposed to UI and app code.
abstract interface class PaymentService {
  Future<CreateInvoiceResult> createInvoice(PaysYouInvoice invoice);

  Future<CreateInvoiceResult> pay(PaysYouInvoice invoice);

  Future<void> launchPaymentApp(CreateInvoiceResult result);
}
