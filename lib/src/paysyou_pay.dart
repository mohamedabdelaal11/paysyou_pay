import 'api/invoice_api.dart';
import 'api/paysyou_pay_api_client.dart';
import 'launcher/deep_link_launcher.dart';
import 'models/create_invoice_result.dart';
import 'models/paysyou_invoice.dart';
import 'models/paysyou_pay_config.dart';
import 'payment_service.dart';

/// High-level entry point for PaysYou Pay integrations.
///
/// Depends on abstractions ([InvoiceApi], [DeepLinkLauncher]) so callers can
/// substitute implementations for testing or custom behavior.
final class PaysYouPay implements PaymentService {
  PaysYouPay({
    PaysYouPayConfig config = const PaysYouPayConfig(),
    InvoiceApi? invoiceApi,
    DeepLinkLauncher? launcher,
  })  : _invoiceApi = invoiceApi ?? PaysYouPayApiClient(config: config),
        _launcher = launcher ?? const DefaultDeepLinkLauncher();

  final InvoiceApi _invoiceApi;
  final DeepLinkLauncher _launcher;

  /// Creates an invoice and returns the parsed API result.
  @override
  Future<CreateInvoiceResult> createInvoice(PaysYouInvoice invoice) {
    return _invoiceApi.createInvoice(invoice);
  }

  /// Prepares a payment and returns the full backend payload.
  ///
  /// Use [CreateInvoiceResult.redirectUrl] for web views/browser flows and
  /// [CreateInvoiceResult.redirectDeepLink] to open the PaysYou app manually.
  @override
  Future<CreateInvoiceResult> pay(PaysYouInvoice invoice) {
    return createInvoice(invoice);
  }

  /// Opens the PaysYou app using the deep link from a prepared payment.
  @override
  Future<void> launchPaymentApp(CreateInvoiceResult result) async {
    await launchDeepLinkOrThrow(_launcher, result.redirectDeepLink);
  }

  /// Convenience helper for one-tap flows that should prepare and launch.
  Future<CreateInvoiceResult> payAndLaunch(PaysYouInvoice invoice) async {
    final result = await pay(invoice);
    await launchPaymentApp(result);
    return result;
  }
}
