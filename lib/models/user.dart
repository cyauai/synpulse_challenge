import 'package:synpulse_challenge/models/stock.dart';

late User user;

class User {
  String id;
  List<Ticker> tickers;

  User({
    required this.id,
    this.tickers = const [],
  });
}
