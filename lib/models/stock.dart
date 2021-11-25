List<Ticker> tickers = [];

List<Ticker> getMatchesSymbolTicker(List<String> symbols) {
  List<Ticker> result = [];
  tickers.forEach((element) {
    if (symbols.contains(element.symbol)) {
      result.add(element);
    }
  });
  return [...result];
}

List<String> getMatchesSymbol(Map data) {
  List<String> result = [];
  data['bestMatches'].forEach((value) {
    result.add(value['1. symbol']);
  });
  return result;
}

Map<String, num> getQuote(Map data) {
  final quote = data['Global Quote'];
  return {
    'change': quote['change'],
    'change percent': quote['change percent'],
    'price': quote['price'],
  };
}

class Ticker {
  final String name;
  final String symbol;
  bool followed;
  List<Map<String, dynamic>> prices;
  Map<String, num> quote;

  Ticker({
    this.name = '',
    this.symbol = '',
    this.prices = const [],
    this.followed = false,
    this.quote = const {
      'change': 0,
      'change percent': 0,
      'previous close': 0,
    },
  });

  @override
  String toString() {
    return prices.toString();
  }

  void toggleFollow() {
    followed = !followed;
  }

  static Ticker fromJson(Map data) {
    final name = data['Meta Data']['2. Symbol'];
    final symbol = data['Meta Data']['2. Symbol'];
    final interval = data['Meta Data']['4. Interval'];
    final List<Map<String, dynamic>> prices = [];
    data['Time Series ($interval)'].forEach((time, detail) {
      prices.add({time: double.parse(detail['1. open'])});
    });
    return Ticker(name: name, symbol: symbol, prices: prices);
  }
}
