import 'package:flutter_test/flutter_test.dart';

import 'package:paysyou_pay_example/main.dart';

void main() {
  testWidgets('example app renders checkout tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const PaysYouPayExampleApp());

    expect(find.text('PaysYou Pay Demo'), findsOneWidget);
    expect(find.text('Filled'), findsOneWidget);
    expect(find.text('Outlined'), findsOneWidget);
    expect(find.text('Custom'), findsOneWidget);
    expect(find.text('Response'), findsOneWidget);
    expect(find.text('Order summary'), findsOneWidget);
  });
}
