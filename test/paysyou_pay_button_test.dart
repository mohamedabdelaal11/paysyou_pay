import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:paysyou_pay/paysyou_pay.dart';

class _MockPaymentService extends Mock implements PaymentService {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const CreateInvoiceResult(
        status: 200,
        message: 'Payment prepared successfully.',
        theTotal: 0,
        invoiceId: 0,
        redirectUrl: 'https://pays-you.com/bill/0',
        redirectDeepLink: 'https://pays-you.com/deeplink/bill?id=0',
        errors: {},
        rawBody: {
          'status': 200,
          'message': 'Payment prepared successfully.',
          'the_total': 0,
          'data': {
            'invoice_id': 0,
            'redirect_url': 'https://pays-you.com/bill/0',
            'redirect_deep_link': 'https://pays-you.com/deeplink/bill?id=0',
          },
          'errors': {},
        },
      ),
    );
  });

  late _MockPaymentService paysYouPay;

  const invoice = PaysYouInvoice(
    amount: '25.00',
    secretKey: 'secret',
    callbackUrl: 'https://example.com/callback',
  );

  setUp(() {
    paysYouPay = _MockPaymentService();
  });

  testWidgets('calls pay on tap and shows loading via custom builder',
      (tester) async {
    when(() => paysYouPay.pay(invoice)).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      return const CreateInvoiceResult(
        status: 200,
        message: 'Payment prepared successfully.',
        theTotal: 0,
        invoiceId: 1,
        redirectUrl: 'https://pays-you.com/bill/1',
        redirectDeepLink: 'https://pays-you.com/deeplink/bill?id=1',
        errors: {},
        rawBody: {
          'status': 200,
          'message': 'Payment prepared successfully.',
          'the_total': 0,
          'data': {
            'invoice_id': 1,
            'redirect_url': 'https://pays-you.com/bill/1',
            'redirect_deep_link': 'https://pays-you.com/deeplink/bill?id=1',
          },
          'errors': {},
        },
      );
    });
    when(
      () => paysYouPay.launchPaymentApp(any()),
    ).thenAnswer((_) async {});

  PaysYouPayException? capturedError;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PaysYouPayButton(
            paysYouPay: paysYouPay,
            invoice: invoice,
            builder: (context, onPressed, isLoading) {
              return ElevatedButton(
                onPressed: onPressed,
                child: Text(isLoading ? 'Loading' : 'Pay'),
              );
            },
            onError: (error) => capturedError = error,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Pay'));
    await tester.pump();
    expect(find.text('Loading'), findsOneWidget);

    await tester.pumpAndSettle();
    verify(() => paysYouPay.pay(invoice)).called(1);
    verify(() => paysYouPay.launchPaymentApp(any())).called(1);
    expect(capturedError, isNull);
  });

  testWidgets('invokes onError when pay fails', (tester) async {
    when(() => paysYouPay.pay(invoice))
        .thenThrow(const PaysYouPayApiException('Payment failed'));

    PaysYouPayException? capturedError;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PaysYouPayButton(
            paysYouPay: paysYouPay,
            invoice: invoice,
            onError: (error) => capturedError = error,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Buy with PaysYou'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(capturedError, isA<PaysYouPayApiException>());
    expect(capturedError!.message, 'Payment failed');
  });
}
