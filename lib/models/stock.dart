class Stock {
  final String name;
  final String symbol;
  final List<Map<String, dynamic>> prices;

  Stock({
    this.name = '',
    this.symbol = '',
    this.prices = const [],
  });

  @override
  String toString() {
    return prices.toString();
  }

  static Stock fromJson(Map data) {
    final name = data['Meta Data']['2. Symbol'];
    final symbol = data['Meta Data']['2. Symbol'];
    final interval = data['Meta Data']['4. Interval'];
    final List<Map<String, dynamic>> prices = [];
    data['Time Series ($interval)'].forEach((time, detail) {
      prices.add({time: double.parse(detail['1. open'])});
    });
    return Stock(name: name, symbol: symbol, prices: prices);
  }
}
