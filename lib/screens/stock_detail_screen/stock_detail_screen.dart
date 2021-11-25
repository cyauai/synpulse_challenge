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
  late List<Map<dynamic, dynamic>> timeSeriesStatus;
  late bool isLoading;
  @override
  void initState() {
    timeSeriesStatus = [
      {
        'name': '1d',
        'isPressed': true,
        'type': 'daily',
      },
      {
        'name': '7d',
        'isPressed': false,
        'type': 'weekly',
      },
      {
        'name': '30d',
        'isPressed': false,
        'type': 'monthly',
      },
      {
        'name': 'All',
        'isPressed': false,
        'type': 'all',
      },
    ];
    fetchData();
    isLoading = true;
    super.initState();
  }

  void fetchData() async {
    await getStockTimeSeriesData('daily');
    isLoading = false;
  }

  void setTimeSeries(String type) async {
    isLoading = true;
    getStockTimeSeriesData(type);
    timeSeriesStatus = timeSeriesStatus.map((e) {
      if (e['type'] != type) {
        e['isPressed'] = false;
      } else {
        e['isPressed'] = true;
      }
      return e;
    }).toList();
    setState(() {});
  }

  Future getStockTimeSeriesData(String type) async {
    final response = await stockTimeSeriesApi(
      {
        'function': "${stockTimeSeriesFunctionNames['$type']}",
        "symbol": "${widget.ticker.symbol}",
        'outputSize': type == 'all' ? 'full' : 'compact',
        'type': type,
      },
    );
    widget.ticker.prices = Ticker.fromJson(response).prices;
    isLoading = false;
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
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
                onPressed: () {
                  widget.setScreen('dashboard');
                },
                icon: Icon(
                  Icons.arrow_back_outlined,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {
                  Share.share('www.google.com', subject: 'wtf');
                },
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
                    decoration: BoxDecoration(
                      color: widget.ticker.quote['change percent']! > 0
                          ? Colors.green[100]
                          : Colors.red[100],
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                    ),
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
          SizedBox(
            height: 10,
          ),
          // time serires toggle button

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final timeSeries in timeSeriesStatus)
                TimeSeriesButton(
                  function: () {
                    setTimeSeries('${timeSeries['type']}');
                  },
                  name: timeSeries['name'],
                  isPressed: timeSeries['isPressed'],
                ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          // Graph
          isLoading
              ? Container(
                  height: 300,
                  child: Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : Container(
                  height: 300,
                  child: _buildDefaultLineChart(widget.ticker),
                ),
          SizedBox(
            height: 10,
          ),
          // Follow button
          InkWell(
            onTap: () {
              widget.ticker.toggleFollow();
              setState(() {});
            },
            child: Container(
              alignment: Alignment.center,
              width: screenSize.width * 0.7,
              height: 50,
              decoration: BoxDecoration(
                border: widget.ticker.followed
                    ? null
                    : Border.all(color: Colors.grey[300]!),
                color: widget.ticker.followed ? Colors.blueGrey : Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                widget.ticker.followed ? 'Followed' : 'Follow',
                style: TextStyle(
                  fontSize: 22,
                  color:
                      widget.ticker.followed ? Colors.white : Colors.blueGrey,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // News section
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
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        decoration: BoxDecoration(
          color: isPressed ? Colors.blueGrey : Colors.grey[200],
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
      ),
    );
  }
}
