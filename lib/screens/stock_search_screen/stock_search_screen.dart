import 'package:flutter/material.dart';
import 'package:synpulse_challenge/api_manager.dart';
import 'package:synpulse_challenge/models/stock.dart';
import 'package:yahoofin/yahoofin.dart';

class StockSearchScreen extends StatefulWidget {
  const StockSearchScreen({
    Key? key,
    required this.setScreen,
  }) : super(key: key);
  final Function setScreen;
  @override
  _StockSearchScreenState createState() => _StockSearchScreenState();
}

class _StockSearchScreenState extends State<StockSearchScreen> {
  late List<Ticker> filteredTicker;
  late TextEditingController searchController;

  void setFilteredTicker(String text) async {
    // if (text.isEmpty) {
    //   filteredTicker = [...tickers];
    // } else {
    //   final result = await searchTickerApi(text);
    //   final symbols = getMatchesSymbol(result);
    //   filteredTicker = getMatchesSymbolTicker(symbols);
    // }

    final yfin = YahooFin();
    print(await yfin.checkSymbol('BA'));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    filteredTicker = tickers;
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    print(tickers);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // header
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.setScreen('dashboard');
                    },
                    icon: Icon(
                      Icons.clear_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Text(
                  'Choose your interests to follow and trade on your terms.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search_rounded,
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'Search interests to folow',
                  ),
                  controller: searchController,
                  onSubmitted: (value) {
                    setFilteredTicker(value);
                  }),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              child: GridView(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1.0),
                children: <Widget>[
                  for (Ticker ticker in filteredTicker)
                    TickerWidget(
                      ticker: ticker,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TickerWidget extends StatefulWidget {
  const TickerWidget({
    Key? key,
    required this.ticker,
  }) : super(key: key);
  final Ticker ticker;
  @override
  _TickerWidgetState createState() => _TickerWidgetState();
}

class _TickerWidgetState extends State<TickerWidget> {
  Widget get _getFollowButton {
    if (widget.ticker.followed) {
      return Container(
        alignment: Alignment.center,
        width: 150,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            40,
          ),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          'Followed',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.blueGrey,
          ),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        width: 150,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(
            40,
          ),
        ),
        child: Text(
          'Follow',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${widget.ticker.name}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              widget.ticker.toggleFollow();
              setState(() {});
            },
            child: _getFollowButton,
          ),
        ],
      ),
    );
  }
}
