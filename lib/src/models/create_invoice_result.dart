/// Parsed response from the create-invoice API.
class CreateInvoiceResult {
  const CreateInvoiceResult({
    required this.status,
    required this.message,
    required this.theTotal,
    required this.invoiceId,
    required this.redirectUrl,
    required this.redirectDeepLink,
    required this.errors,
    required this.rawBody,
  });

  /// HTTP-style status returned by the backend payload.
  final int status;

  /// Human-readable backend message.
  final String message;

  /// Calculated total returned by the backend.
  final num theTotal;

  /// Backend invoice id.
  final int invoiceId;

  /// Hosted web payment URL for web views or browser flows.
  final String redirectUrl;

  /// Deep link that opens the PaysYou app to complete payment.
  final String redirectDeepLink;

  /// Backend errors object, if present.
  final Map<String, dynamic> errors;

  /// Full raw backend payload.
  final Map<String, dynamic> rawBody;

  Map<String, dynamic> toJson() => rawBody;
}
