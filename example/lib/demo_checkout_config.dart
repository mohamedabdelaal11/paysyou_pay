import 'package:paysyou_pay/paysyou_pay.dart';

/// Demo checkout configuration. Replace with your provider credentials.
abstract final class DemoCheckoutConfig {
  static const secretKey = 'pays_4595_code_7535';
  static const callbackUrl =
      'https://langua.dev-moltaqa.cloud/client-api/v1/test_callback_pays_you';
  static const coupon = '';
  static const products = [
    PaysYouProduct(
      name: PaysYouProductName(
        ar: '2خدمة استشارة',
        en: 'Consultation Service2',
      ),
      code: 'SVC-001',
      price: 50,
      quantity: 3,
    ),
    PaysYouProduct(
      name: PaysYouProductName(
        ar: 'فحص طبي',
        en: 'Medical Checkup',
      ),
      price: 120,
      quantity: 1,
    ),
    PaysYouProduct(
      name: PaysYouProductName(
        ar: 'تقرير طبي',
        en: 'Medical Report',
      ),
      code: 'RPT-010',
      price: 30,
      quantity: 2,
    ),
  ];
}
