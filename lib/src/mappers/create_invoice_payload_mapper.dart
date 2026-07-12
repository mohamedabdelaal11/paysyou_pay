import 'package:intl/intl.dart';

import '../models/paysyou_invoice.dart';

/// Maps [PaysYouInvoice] to the create-invoice API request body.
abstract interface class CreateInvoicePayloadMapper {
  Map<String, dynamic> toJson(PaysYouInvoice invoice);
}

/// Default JSON mapper for the PaysYou create-invoice endpoint.
final class PaysYouCreateInvoicePayloadMapper
    implements CreateInvoicePayloadMapper {
  PaysYouCreateInvoicePayloadMapper({DateFormat? dateFormat})
      : _dateFormat = dateFormat ?? DateFormat('yyyy-MM-dd');

  final DateFormat _dateFormat;

  @override
  Map<String, dynamic> toJson(PaysYouInvoice invoice) {
    final payload = <String, dynamic>{
      'code': invoice.secretKey,
      'total': invoice.amount,
      'invoice_date': _dateFormat.format(invoice.resolvedInvoiceDate),
      'call_back_url': invoice.callbackUrl,
    };

    final coupon = invoice.coupon?.trim();
    if (coupon != null && coupon.isNotEmpty) {
      payload['coupon'] = coupon;
    }

    return payload;
  }
}
