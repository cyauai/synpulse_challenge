import 'package:flutter/material.dart';
import 'package:synpulse_challenge/models/stock.dart';
import 'package:synpulse_challenge/models/user.dart';
import '../../api_manager.dart';
import '../../widgets/see_all_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    Key? key,
    required this.setScreen,
    required this.setTicker,
  }) : super(key: key);
  final Function setScreen;
  final Function setTicker;
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchData() async {
    if (!loadedQuote) {
      await Future.delayed(
        Duration(
          milliseconds: 1500,
        ),
      );

      List<Ticker> savedTickers =
          getMatchesSymbolTicker(appUser.savedTickerSymbols);
      for (int i = 0; i < savedTickers.length; i++) {
        if (savedTickers[i].notGetQuote) {
          final quoteData = await tickerQuoteApi(savedTickers[i].symbol);
          savedTickers[i].quote = getQuote(quoteData);

          final detailData = await tickerDetailApi(savedTickers[i].symbol);
          savedTickers[i].logoUrl = detailData['logo'];
          savedTickers[i].url = detailData['url'];

          savedTickers[i].followed = true;
        }
      }

      loadedQuote = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Ticker> watchListTickers = getFollowedTickers;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.setScreen('stock search');
                },
                icon: Icon(
                  Icons.search_rounded,
                  size: 30,
                ),
              ),
            ],
          ),
          Divider(),
          // gainers and losers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gainer and Losers',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // SeeAllWidget(function: () {}),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          loadedQuote
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final ticker in watchListTickers)
                        if (ticker.quote.isNotEmpty)
                          InkWell(
                            onTap: () {
                              widget.setScreen('stock detail');
                              widget.setTicker(ticker.symbol);
                            },
                            child: GainerWidget(
                              ticker: ticker,
                            ),
                          ),
                    ],
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                ),

          SizedBox(
            height: 20,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your watchlist',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // SeeAllWidget(function: () {}),
            ],
          ),
          // watch list
          loadedQuote
              ? Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (final ticker in watchListTickers)
                          if (ticker.quote.isNotEmpty)
                            InkWell(
                              onTap: () {
                                widget.setScreen('stock detail');
                                widget.setTicker(ticker.symbol);
                              },
                              child: WatchlistWidget(
                                ticker: ticker,
                              ),
                            ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
        ],
      ),
    );
  }
}

class GainerWidget extends StatelessWidget {
  const GainerWidget({Key? key, required this.ticker}) : super(key: key);
  final Ticker ticker;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 30.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (ticker.logoUrl.isNotEmpty)
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage('${ticker.logoUrl}'),
                  backgroundColor: Colors.transparent,
                ),
              Text(
                '${ticker.name}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${ticker.quote['price']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      color: ticker.quote['change']! > 0
                          ? Colors.green[100]
                          : Colors.red[100],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ticker.quote['change percent']! > 0
                            ? '+\$${ticker.quote['price']}'
                            : '-\$${ticker.quote['price']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: ticker.quote['change']! > 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  () {
                    final String price = ticker.quote['change'].toString();
                    String res;
                    if (ticker.quote['change']! > 0) {
                      res = '+\$$price';
                    } else {
                      res = '-\$${price.substring(1, price.length)}';
                    }
                    return Text(
                      '$res',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey,
                      ),
                    );
                  }(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WatchlistWidget extends StatelessWidget {
  const WatchlistWidget({Key? key, required this.ticker}) : super(key: key);
  final Ticker ticker;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 30,
          ),
          child: Row(
            children: [
              if (ticker.logoUrl.isNotEmpty)
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.star,
                      color: Colors.amber[300],
                    ),
                  ),
                ),
              CircleAvatar(
                radius: 15.0,
                backgroundImage: NetworkImage('${ticker.logoUrl}'),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${ticker.name}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              () {
                final String price = ticker.quote['change percent'].toString();
                String res;
                if (ticker.quote['change percent']! > 0) {
                  res = '+\$$price';
                } else {
                  res = '-\$${price.substring(1, price.length)}';
                }
                return Expanded(
                  flex: 3,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '$res',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ticker.quote['change percent']! > 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                );
              }(),
              Expanded(
                flex: 3,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '\$${ticker.quote['price']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
