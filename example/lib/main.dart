import 'package:flutter/material.dart';
import 'package:paysyou_pay/paysyou_pay.dart';

import 'demo_checkout_config.dart';

void main() {
  runApp(const PaysYouPayExampleApp());
}

class PaysYouPayExampleApp extends StatelessWidget {
  const PaysYouPayExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaysYou Pay Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: PaysYouPayTheme.primary),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: PaysYouPayTheme.secondary,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CheckoutDemoPage(),
    );
  }
}

class CheckoutDemoPage extends StatefulWidget {
  const CheckoutDemoPage({super.key});

  @override
  State<CheckoutDemoPage> createState() => _CheckoutDemoPageState();
}

class _CheckoutDemoPageState extends State<CheckoutDemoPage> {
  late final PaysYouPay _paysYouPay;
  String? _statusMessage;
  CreateInvoiceResult? _lastPreparedPayment;

  @override
  void initState() {
    super.initState();
    _paysYouPay = PaysYouPay();
  }

  double get _total => DemoCheckoutConfig.products.fold<double>(
        0,
        (sum, product) => sum + product.price.toDouble() * product.quantity,
      );

  PaysYouInvoice get _invoice => PaysYouInvoice(
        amount: _total.toStringAsFixed(2),
        secretKey: DemoCheckoutConfig.secretKey,
        callbackUrl: DemoCheckoutConfig.callbackUrl,
        coupon: DemoCheckoutConfig.coupon.isEmpty
            ? null
            : DemoCheckoutConfig.coupon,
        products: DemoCheckoutConfig.products,
        invoiceDate: DateTime.now(),
      );

  void _setStatus(String message) {
    setState(() => _statusMessage = message);
  }

  Future<void> _preparePayment() async {
    try {
      final result = await _paysYouPay.pay(_invoice);
      setState(() {
        _lastPreparedPayment = result;
        _statusMessage = result.message;
      });
    } on PaysYouPayException catch (error) {
      _setStatus(error.message);
    }
  }

  Future<void> _openInApp() async {
    final result = _lastPreparedPayment;
    if (result == null) {
      _setStatus('Prepare payment first to get redirect_deep_link.');
      return;
    }

    try {
      await _paysYouPay.launchPaymentApp(result);
      _setStatus('Opened PaysYou app using redirect_deep_link.');
    } on PaysYouPayException catch (error) {
      _setStatus(error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PaysYou Pay Demo'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Filled'),
              Tab(text: 'Outlined'),
              Tab(text: 'Custom'),
              Tab(text: 'Response'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _CheckoutTab(
              summary: _buildSummary(context),
              statusMessage: _statusMessage,
              button: PaysYouPayButton(
                paysYouPay: _paysYouPay,
                invoice: _invoice,
                // label: 'Buy with PaysYou',
                borderRadius: 18,
                onSuccess: () =>
                    _setStatus('Invoice created. Opening app…'),
                onError: (error) => _setStatus(error.message),
              ),
            ),
            _CheckoutTab(
              summary: _buildSummary(context),
              statusMessage: _statusMessage,
              button: PaysYouPayButton(
                paysYouPay: _paysYouPay,
                invoice: _invoice,
                style: PaysYouPayButtonStyle.outlined,
                // label: 'Buy with PaysYou',
                borderRadius: 18,
                onSuccess: () =>
                    _setStatus('Invoice created. Opening app…'),
                onError: (error) => _setStatus(error.message),
              ),
            ),
            _CheckoutTab(
              summary: _buildSummary(context),
              statusMessage: _statusMessage,
              button: PaysYouPayButton(
                paysYouPay: _paysYouPay,
                invoice: _invoice,
                builder: (context, onPressed, isLoading) {
                  final colors = PaysYouPayTheme.gradientFor(
                    Theme.of(context).brightness,
                  ).colors;
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors.last.withValues(alpha: 0.28),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(
                          PaysYouPayTheme.buttonHeight,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: onPressed,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const PaysYouPayLogo(size: 30),
                          const SizedBox(width: 12),
                          Text(
                            isLoading ? 'Processing...' : 'Buy with PaysYou',
                          ),
                        ],
                      ),
                    ),
                  );
                },
                onSuccess: () =>
                    _setStatus('Invoice created. Opening app…'),
                onError: (error) => _setStatus(error.message),
              ),
            ),
            _CheckoutTab(
              summary: _ResponseDemoCard(
                result: _lastPreparedPayment,
                onPreparePayment: _preparePayment,
                onOpenInApp: _openInApp,
              ),
              statusMessage: _statusMessage,
              button: FilledButton(
                onPressed: _preparePayment,
                child: const Text('Prepare Payment Response'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    return _SummaryCard(
      total: _total,
      products: DemoCheckoutConfig.products,
    );
  }
}

class _CheckoutTab extends StatelessWidget {
  const _CheckoutTab({
    required this.summary,
    required this.button,
    this.statusMessage,
  });

  final Widget summary;
  final Widget button;
  final String? statusMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                summary,
                if (statusMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    statusMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: button,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.total,
    required this.products,
  });

  final double total;
  final List<PaysYouProduct> products;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order summary',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            for (final product in products)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${product.name.en} x${product.quantity}',
                      ),
                    ),
                    Text(
                      (product.price * product.quantity).toStringAsFixed(2),
                    ),
                  ],
                ),
              ),
            const Divider(),
            _PriceRow(
              label: 'Total',
              value: total,
              isEmphasized: true,
            ),
            const SizedBox(height: 12),
            Text(
              'Set your provider key in demo_checkout_config.dart',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResponseDemoCard extends StatelessWidget {
  const _ResponseDemoCard({
    required this.result,
    required this.onPreparePayment,
    required this.onOpenInApp,
  });

  final CreateInvoiceResult? result;
  final Future<void> Function() onPreparePayment;
  final Future<void> Function() onOpenInApp;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Custom business flow',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'This example prepares payment first, then lets your app decide how to continue.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _InfoTile(
              title: 'redirect_url',
              value: result?.redirectUrl ??
                  'Use this hosted URL in a WebView or browser.',
            ),
            const SizedBox(height: 12),
            _InfoTile(
              title: 'redirect_deep_link',
              value: result?.redirectDeepLink ??
                  'Use this to open the PaysYou app via deep link.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton(
                  onPressed: onPreparePayment,
                  child: const Text('Prepare Payment'),
                ),
                FilledButton.tonal(
                  onPressed: result == null ? null : onOpenInApp,
                  child: const Text('Open App Deep Link'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Returned JSON',
              style: textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                _prettyJson(result),
                style: textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _prettyJson(CreateInvoiceResult? result) {
    if (result == null) {
      return '''{
  "status": 200,
  "message": "Payment prepared successfully.",
  "the_total": 0,
  "data": {
    "invoice_id": 150,
    "redirect_url": "https://pays-you.com/bill/150",
    "redirect_deep_link": "https://pays-you.com/deeplink/bill?id=150"
  },
  "errors": {}
}''';
    }

    final json = result.toJson();
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return '''{
  "status": ${json['status']},
  "message": "${json['message']}",
  "the_total": ${json['the_total']},
  "data": {
    "invoice_id": ${data['invoice_id']},
    "redirect_url": "${data['redirect_url']}",
    "redirect_deep_link": "${data['redirect_deep_link']}"
  },
  "errors": ${json['errors']}
}''';
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 4),
        SelectableText(value),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.isEmphasized = false,
  });

  final String label;
  final double value;
  final bool isEmphasized;

  @override
  Widget build(BuildContext context) {
    final style = isEmphasized
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value.toStringAsFixed(2), style: style),
        ],
      ),
    );
  }
}
