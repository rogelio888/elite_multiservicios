import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyNotifier extends Notifier<String> {
  @override
  String build() => 'BOB';

  void setCurrency(String val) => state = val;
}

final currencyProvider = NotifierProvider<CurrencyNotifier, String>(() {
  return CurrencyNotifier();
});

class ExchangeRateNotifier extends Notifier<double> {
  @override
  double build() => 6.96;

  void setRate(double val) => state = val;
}

final exchangeRateProvider = NotifierProvider<ExchangeRateNotifier, double>(() {
  return ExchangeRateNotifier();
});
