import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:paysyou_pay/paysyou_pay.dart';

class _MockDio extends Mock implements Dio {}

class _MockResponse extends Mock
    implements Response<Map<String, dynamic>> {}

void main() {
  late _MockDio dio;
  late PaysYouPayApiClient client;

  final invoice = PaysYouInvoice(
    amount: '67.00',
    secretKey: 'test_secret',
    callbackUrl: 'https://example.com/callback',
    coupon: 'SAVE10',
    invoiceDate: DateTime(2026, 7, 9),
  );

  setUp(() {
    dio = _MockDio();
    client = PaysYouPayApiClient(
      config: PaysYouPayConfig(dio: dio),
    );
  });

  group('PaysYouPayApiClient', () {
    test('sends expected payload and parses response', () async {
      final response = _MockResponse();
      when(() => response.data).thenReturn({
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

      when(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => response);

      final result = await client.createInvoice(invoice);

      expect(result.status, 200);
      expect(result.message, 'Payment prepared successfully.');
      expect(result.theTotal, 0);
      expect(result.invoiceId, 150);
      expect(result.redirectUrl, 'https://pays-you.com/bill/150');
      expect(
        result.redirectDeepLink,
        'https://pays-you.com/deeplink/bill?id=150',
      );
      expect(result.toJson()['status'], 200);

      final captured = verify(
        () => dio.post<Map<String, dynamic>>(
          'https://backend.pays-you.com/facility-api/v1/pay_invoice',
          data: captureAny(named: 'data'),
          options: captureAny(named: 'options'),
        ),
      ).captured;

      final payload = captured[0] as Map<String, dynamic>;
      expect(payload['code'], 'test_secret');
      expect(payload['total'], '67.00');
      expect(payload['invoice_date'], '2026-07-09');
      expect(payload['coupon'], 'SAVE10');
      expect(payload['call_back_url'], 'https://example.com/callback');
    });

    test('omits coupon when null or empty', () async {
      final response = _MockResponse();
      when(() => response.data).thenReturn({
        'status': 200,
        'message': 'Payment prepared successfully.',
        'the_total': 0,
        'data': {
          'invoice_id': 151,
          'redirect_url': 'https://pays-you.com/bill/151',
          'redirect_deep_link': 'https://pays-you.com/deeplink/bill?id=151',
        },
        'errors': <String, dynamic>{},
      });

      when(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => response);

      await client.createInvoice(
        const PaysYouInvoice(
          amount: '10.00',
          secretKey: 'key',
          callbackUrl: 'https://example.com/callback',
        ),
      );

      final payload = verify(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: captureAny(named: 'data'),
          options: any(named: 'options'),
        ),
      ).captured.first as Map<String, dynamic>;

      expect(payload.containsKey('coupon'), isFalse);
      expect(payload.containsKey('products'), isFalse);
    });

    test('sends products when present', () async {
      final response = _MockResponse();
      when(() => response.data).thenReturn({
        'status': 200,
        'message': 'Payment prepared successfully.',
        'the_total': 0,
        'data': {
          'invoice_id': 152,
          'redirect_url': 'https://pays-you.com/bill/152',
          'redirect_deep_link': 'https://pays-you.com/deeplink/bill?id=152',
        },
        'errors': <String, dynamic>{},
      });

      when(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => response);

      await client.createInvoice(
        const PaysYouInvoice(
          amount: '150.00',
          secretKey: 'key',
          callbackUrl: 'https://example.com/callback',
          products: [
            PaysYouProduct(
              name: PaysYouProductName(
                ar: '2خدمة استشارة',
                en: 'Consultation Service2',
              ),
              code: 'SVC-001',
              price: 50,
              quantity: 3,
            ),
          ],
        ),
      );

      final payload = verify(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: captureAny(named: 'data'),
          options: any(named: 'options'),
        ),
      ).captured.first as Map<String, dynamic>;

      expect(payload['products'], [
        {
          'name': {'ar': '2خدمة استشارة', 'en': 'Consultation Service2'},
          'code': 'SVC-001',
          'price': 50,
          'quantity': 3,
        },
      ]);
    });

    test('maps DioException to PaysYouPayApiException', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 400,
            data: {'message': 'Invalid provider key'},
          ),
        ),
      );

      expect(
        () => client.createInvoice(invoice),
        throwsA(
          isA<PaysYouPayApiException>()
              .having((e) => e.message, 'message', 'Invalid provider key')
              .having((e) => e.statusCode, 'statusCode', 400),
        ),
      );
    });
  });
}
