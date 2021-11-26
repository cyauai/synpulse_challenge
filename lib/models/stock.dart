import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synpulse_challenge/models/user.dart';

import 'news.dart';

bool loadedQuote = false;

List<Ticker> tickers = [
  Ticker(
    name: 'Apple',
    symbol: 'AAPL',
  ),
  Ticker(
    name: 'Microsoft',
    symbol: 'MSFT',
  ),
  Ticker(
    name: 'Google',
    symbol: 'GOOG',
  ),
  Ticker(
    name: 'Amazon',
    symbol: 'AMZN',
  ),
  Ticker(
    name: 'Tesla',
    symbol: 'TSLA',
  ),
  Ticker(
    name: 'Meta Platform',
    symbol: 'FB',
  ),
  Ticker(
    name: 'NVIDIA',
    symbol: 'NVDA',
  ),
  Ticker(
    name: 'JP Morgan',
    symbol: 'JPM',
  ),
  Ticker(
    name: 'Visa Inc.',
    symbol: 'V',
  ),
  Ticker(
    name: 'Walmart Inc.',
    symbol: 'WMT',
  ),
  Ticker(
    name: 'IBM',
    symbol: 'IBM',
  ),
  Ticker(
    name: 'Netflix',
    symbol: 'NTLX',
  ),
  Ticker(
    name: 'Adobe',
    symbol: 'ADBE',
  ),
  Ticker(
    name: 'Mastercard',
    symbol: 'MA',
  ),
  Ticker(
    name: 'PepsiCo',
    symbol: 'PEP',
  ),
  Ticker(
    name: 'Coca-cola',
    symbol: 'KO',
  ),
];

List<Ticker> get getFollowedTickers {
  return tickers.where((element) => element.followed).toList();
}

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
  final quote = data.values.first;
  try {
    return {
      'change': double.parse(quote['09. change'] ?? 0),
      'change percent': double.parse(quote['10. change percent'] == null
          ? 0
          : quote['10. change percent']
              .substring(0, quote['10. change percent'].length - 1)),
      'price': double.parse(quote['05. price'] ?? 0),
    };
  } catch (e) {
    print(e);
    return {};
  }
}

class Ticker {
  final String name;
  final String symbol;
  bool followed;
  Map<String, List<Map<String, dynamic>>> prices;
  Map<String, num> quote;
  List<News> newsList;
  String logoUrl;
  String url;
  Ticker({
    this.name = '',
    this.symbol = '',
    this.prices = const {},
    this.followed = false,
    this.quote = const {
      'change': 0,
      'change percent': 0,
      'price': 0,
    },
    this.newsList = const [],
    this.logoUrl = '',
    this.url = '',
  });

  @override
  String toString() {
    return symbol;
  }

  bool get notGetQuote {
    return quote['change'] == 0 &&
        quote['change percent'] == 0 &&
        quote['price'] == 0;
  }

  Future<String> toggleFollow() async {
    followed = !followed;
    if (getFollowedTickers.length > 5) {
      followed = !followed;
      return 'full';
    }

    final doc =
        FirebaseFirestore.instance.collection('users').doc('${appUser.id}');
    await doc.set({
      'savedTickerSymbols': getFollowedTickers.map((e) => e.symbol).toList(),
      'id': appUser.id
    });

    appUser.savedTickerSymbols =
        getFollowedTickers.map((e) => e.symbol).toList();

    loadedQuote = false;

    return 'success';
  }

  static Ticker fromJson(Map data) {
    final name = data['Meta Data']['2. Symbol'];
    final symbol = data['Meta Data']['2. Symbol'];
    final interval = data['Meta Data']['4. Interval'];
    final List<Map<String, dynamic>> prices = [];

    if (interval == null) {
      final key =
          data.keys.firstWhere((element) => element.contains('Time Series'));
      data[key].forEach((time, detail) {
        prices.add({time: double.parse(detail['1. open'])});
      });
    } else {
      data['Time Series ($interval)'].forEach((time, detail) {
        prices.add({time: double.parse(detail['1. open'])});
      });
    }
    return Ticker(name: name, symbol: symbol, prices: {data['type']: prices});
  }
}
