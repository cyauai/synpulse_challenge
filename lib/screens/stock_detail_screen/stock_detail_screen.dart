import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:synpulse_challenge/models/stock.dart';

import '../../api_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockDetailScreen extends StatefulWidget {
  const StockDetailScreen(
      {Key? key, required this.setScreen, required this.ticker})
      : super(key: key);
  final Function setScreen;
  final Ticker ticker;
  @override
  _StockDetailScreenState createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  late Ticker currentTicker;
  late List<Map<dynamic, dynamic>> timeSeriesStatus;
  @override
  void initState() {
    currentTicker = Ticker();

    timeSeriesStatus = [
      {
        'name': '1d',
        'isPressed': true,
        'param': {
          'function': 'TIME_SERIES_INTRADAY',
          'interval': '30min',
        },
      }
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_back_outlined,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.share_outlined,
                  size: 30,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          // Ticker info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${widget.ticker.symbol}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 5,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${widget.ticker.name}',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Ticker quote
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 5,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    '\$${widget.ticker.quote['price']}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    color: widget.ticker.quote['change percent']! > 0
                        ? Colors.green[100]
                        : Colors.red[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${widget.ticker.quote['change percent']}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: widget.ticker.quote['change percent']! > 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  () {
                    final String price =
                        widget.ticker.quote['change'].toString();
                    String res;
                    if (widget.ticker.quote['change']! > 0) {
                      res = '\$$price';
                    } else {
                      res = '-\$${price.substring(1, price.length)}';
                    }
                    return Text(
                      '$res',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey,
                      ),
                    );
                  }(),
                ],
              ),
            ),
          ),
          // time serires toggle button
          TimeSeriesButton(
            function: () {},
            name: '1d',
            isPressed: true,
          ),
          _buildDefaultLineChart(currentTicker),
          TextButton(
            child: Text("HI"),
            onPressed: () async {
              // var url = Uri.parse(
              //     'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=5min&apikey=$APIKEY');
              // var response = await http.get(url);

              // currentTicker = Stock.fromJson(json.decode(response.body));
              // tickerListApi();
              Share.share('www.google.com', subject: 'wtf');
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildDefaultLineChart(Ticker currentTicker) {
  if (currentTicker.symbol.isEmpty) {
    return Container();
  }
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(
      isVisible: false,
    ), // Initialize category axis.
    series: <LineSeries<Map<String, dynamic>, String>>[
      // Initialize line series.
      LineSeries<Map<String, dynamic>, String>(
        dataSource: [...currentTicker.prices],
        xValueMapper: (Map<String, dynamic> price, _) => price.keys.first,
        yValueMapper: (Map<String, dynamic> price, _) => price.values.first,
      ),
    ],
  );
}

class TimeSeriesButton extends StatelessWidget {
  const TimeSeriesButton({
    Key? key,
    required this.name,
    required this.function,
    required this.isPressed,
  }) : super(key: key);
  final String name;
  final bool isPressed;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isPressed ? Colors.blueGrey : Colors.white,
        borderRadius: BorderRadius.circular(
          5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16,
        ),
        child: Text(
          '$name',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isPressed ? Colors.white : Colors.blueGrey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
