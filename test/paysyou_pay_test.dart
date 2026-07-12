import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:paysyou_pay/paysyou_pay.dart';

class _MockInvoiceApi extends Mock implements InvoiceApi {}

class _MockDeepLinkLauncher extends Mock implements DeepLinkLauncher {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  late _MockInvoiceApi invoiceApi;
  late _MockDeepLinkLauncher launcher;
  late PaysYouPay paysYouPay;

  const invoice = PaysYouInvoice(
    amount: '50.00',
    secretKey: 'secret',
    callbackUrl: 'https://example.com/callback',
  );

  setUp(() {
    invoiceApi = _MockInvoiceApi();
    launcher = _MockDeepLinkLauncher();
    paysYouPay = PaysYouPay(
      invoiceApi: invoiceApi,
      launcher: launcher,
    );
  });

  test('createInvoice delegates to InvoiceApi', () async {
    when(() => invoiceApi.createInvoice(invoice)).thenAnswer(
      (_) async => const CreateInvoiceResult(
        status: 200,
        message: 'Payment prepared successfully.',
        theTotal: 0,
        invoiceId: 99,
        redirectUrl: 'https://pays-you.com/bill/99',
        redirectDeepLink: 'https://pays-you.com/deeplink/bill?id=99',
        errors: {},
        rawBody: {
          'status': 200,
          'message': 'Payment prepared successfully.',
          'the_total': 0,
          'data': {
            'invoice_id': 99,
            'redirect_url': 'https://pays-you.com/bill/99',
            'redirect_deep_link':
                'https://pays-you.com/deeplink/bill?id=99',
          },
          'errors': {},
        },
      ),
    );

    final result = await paysYouPay.createInvoice(invoice);

    expect(result.invoiceId, 99);
    verify(() => invoiceApi.createInvoice(invoice)).called(1);
    verifyNever(() => launcher.launch(any()));
  });

  test('pay returns prepared payment without launching', () async {
    when(() => invoiceApi.createInvoice(invoice)).thenAnswer(
      (_) async => const CreateInvoiceResult(
        status: 200,
        message: 'Payment prepared successfully.',
        theTotal: 0,
        invoiceId: 99,
        redirectUrl: 'https://pays-you.com/bill/99',
        redirectDeepLink: 'https://pays-you.com/deeplink/bill?id=99',
        errors: {},
        rawBody: {
          'status': 200,
          'message': 'Payment prepared successfully.',
          'the_total': 0,
          'data': {
            'invoice_id': 99,
            'redirect_url': 'https://pays-you.com/bill/99',
            'redirect_deep_link':
                'https://pays-you.com/deeplink/bill?id=99',
          },
          'errors': {},
        },
      ),
    );

    final result = await paysYouPay.pay(invoice);

    expect(result.redirectUrl, 'https://pays-you.com/bill/99');
    verifyNever(() => launcher.launch(any()));
  });

  test('launchPaymentApp opens redirect deep link', () async {
    when(() => launcher.launch(any())).thenAnswer((_) async => true);

    await paysYouPay.launchPaymentApp(
      const CreateInvoiceResult(
        status: 200,
        message: 'Payment prepared successfully.',
        theTotal: 0,
        invoiceId: 99,
        redirectUrl: 'https://pays-you.com/bill/99',
        redirectDeepLink: 'https://pays-you.com/deeplink/bill?id=99',
        errors: {},
        rawBody: {
          'status': 200,
          'message': 'Payment prepared successfully.',
          'the_total': 0,
          'data': {
            'invoice_id': 99,
            'redirect_url': 'https://pays-you.com/bill/99',
            'redirect_deep_link':
                'https://pays-you.com/deeplink/bill?id=99',
          },
          'errors': {},
        },
      ),
    );

    verify(
      () => launcher.launch(
        Uri.parse('https://pays-you.com/deeplink/bill?id=99'),
      ),
    ).called(1);
  });

  test('launchPaymentApp throws when launcher returns false', () async {
    when(() => launcher.launch(any())).thenAnswer((_) async => false);

    expect(
      () => paysYouPay.launchPaymentApp(
        const CreateInvoiceResult(
          status: 200,
          message: 'Payment prepared successfully.',
          theTotal: 0,
          invoiceId: 99,
          redirectUrl: 'https://pays-you.com/bill/99',
          redirectDeepLink: 'https://pays-you.com/deeplink/bill?id=99',
          errors: {},
          rawBody: {
            'status': 200,
            'message': 'Payment prepared successfully.',
            'the_total': 0,
            'data': {
              'invoice_id': 99,
              'redirect_url': 'https://pays-you.com/bill/99',
              'redirect_deep_link':
                  'https://pays-you.com/deeplink/bill?id=99',
            },
            'errors': {},
          },
        ),
      ),
      throwsA(isA<PaysYouPayLaunchException>()),
    );
  });
}
