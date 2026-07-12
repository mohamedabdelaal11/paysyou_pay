import 'package:flutter_test/flutter_test.dart';
import 'package:paysyou_pay/paysyou_pay.dart';

void main() {
  group('PaysYouInvoiceValidator', () {
    const validator = PaysYouInvoiceValidator();

    test('accepts valid invoice', () {
      expect(
        () => validator.validate(
          const PaysYouInvoice(
            amount: '10.50',
            secretKey: 'secret',
            callbackUrl: 'https://example.com/callback',
          ),
        ),
        returnsNormally,
      );
    });

    test('rejects empty secretKey', () {
      expect(
        () => validator.validate(
          const PaysYouInvoice(
            amount: '10.00',
            secretKey: '  ',
            callbackUrl: 'https://example.com/callback',
          ),
        ),
        throwsA(isA<PaysYouPayValidationException>()),
      );
    });

    test('rejects invalid amount', () {
      expect(
        () => validator.validate(
          const PaysYouInvoice(
            amount: '0',
            secretKey: 'secret',
            callbackUrl: 'https://example.com/callback',
          ),
        ),
        throwsA(isA<PaysYouPayValidationException>()),
      );
    });
  });

  group('PaysYouCreateInvoicePayloadMapper', () {
    test('formats date and includes coupon', () {
      final mapper = PaysYouCreateInvoicePayloadMapper();
      final payload = mapper.toJson(
        PaysYouInvoice(
          amount: '99.00',
          secretKey: 'key',
          callbackUrl: 'https://example.com/callback',
          coupon: 'PROMO',
          invoiceDate: DateTime(2026, 1, 15),
        ),
      );

      expect(payload['invoice_date'], '2026-01-15');
      expect(payload['coupon'], 'PROMO');
    });
  });

  group('PaysYouCreateInvoiceResponseParser', () {
    const parser = PaysYouCreateInvoiceResponseParser();

    test('parses prepared payment payload', () {
      final result = parser.parse({
        'status': 200,
        'message': 'Payment prepared successfully.',
        'the_total': 0,
        'data': {
          'invoice_id': 150,
          'redirect_url': 'https://pays-you.com/bill/150',
          'redirect_deep_link': 'https://pays-you.com/deeplink/bill?id=150',
        },
        'errors': <String, dynamic>{},
      });

      expect(result.status, 200);
      expect(result.invoiceId, 150);
      expect(result.redirectUrl, 'https://pays-you.com/bill/150');
    });

    test('throws when deep link is missing', () {
      expect(
        () => parser.parse({
          'status': 200,
          'message': 'Payment prepared successfully.',
          'the_total': 0,
          'data': {
            'invoice_id': 150,
            'redirect_url': 'https://pays-you.com/bill/150',
          },
          'errors': <String, dynamic>{},
        }),
        throwsA(isA<PaysYouPayApiException>()),
      );
    });
  });
}
