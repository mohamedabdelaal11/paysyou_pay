/// Invoice details sent to the PaysYou create-invoice API.
class PaysYouInvoice {
  const PaysYouInvoice({
    required this.amount,
    required this.secretKey,
    required this.callbackUrl,
    this.invoiceDate,
    this.coupon,
  });

  /// Payment total as a string (e.g. `"99.50"`).
  final String amount;

  /// Provider secret key (`code` in the API payload).
  final String secretKey;

  /// URL the backend calls after payment completes.
  final String callbackUrl;

  /// Invoice date; defaults to [DateTime.now] when omitted.
  final DateTime? invoiceDate;

  /// Optional coupon code.
  final String? coupon;

  /// Resolved invoice date used for API formatting.
  DateTime get resolvedInvoiceDate => invoiceDate ?? DateTime.now();
}
