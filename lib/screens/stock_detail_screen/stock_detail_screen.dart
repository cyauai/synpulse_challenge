import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:synpulse_challenge/models/news.dart';
import 'package:synpulse_challenge/models/stock.dart';
import 'package:synpulse_challenge/screens/stock_detail_screen/news_widget.dart';
import 'package:synpulse_challenge/widgets/message_box.dart';
import 'package:synpulse_challenge/widgets/see_all_widget.dart';

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

  String get getType {
    return timeSeriesStatus
        .firstWhere((element) => element['isPressed'])['type'];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchData() async {
    await getStockTimeSeriesData('daily');
    if (widget.ticker.newsList.isEmpty) {
      final newsResponse = await tickerNewsApi(widget.ticker.symbol);
      widget.ticker.newsList = convertNews(newsResponse);
    }
    if (widget.ticker.logoUrl.isEmpty) {
      final detailData = await tickerDetailApi(widget.ticker.symbol);
      widget.ticker.logoUrl = detailData['logo'];
      widget.ticker.url = detailData['url'];
    }
    isLoading = false;
    setState(() {});
  }

  void setTimeSeries(String type) async {
    try {
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
    } catch (e) {
      showWarningMsg(context, 'Exceed api calls, please try again later');
    }
  }

  Future getStockTimeSeriesData(String type) async {
    if (!widget.ticker.prices.containsKey(type)) {
      try {
        final response = await stockTimeSeriesApi(
          {
            'function': "${stockTimeSeriesFunctionNames['$type']}",
            "symbol": "${widget.ticker.symbol}",
            'outputSize': type == 'all' ? 'full' : 'compact',
            'type': type,
          },
        );
        final temp = Ticker.fromJson(response).prices;
        for (final key in widget.ticker.prices.keys) {
          temp.putIfAbsent(key, () => widget.ticker.prices[key]!);
        }
        widget.ticker.prices = temp;
        isLoading = false;
        setState(() {});
      } catch (e) {
        showWarningMsg(context, 'Exceed api calls, please try again later');
      }
    } else {
      isLoading = false;
      setState(() {});
    }
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
                  Share.share('${widget.ticker.url}', subject: '');
                },
                icon: Icon(
                  Icons.ios_share,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
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
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage('${widget.ticker.logoUrl}'),
                  backgroundColor: Colors.transparent,
                ),
              ],
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
                  height: 250,
                  child: Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : Container(
                  height: 250,
                  child: _buildDefaultLineChart(widget.ticker, getType),
                ),
          SizedBox(
            height: 10,
          ),
          // Follow button
          InkWell(
            onTap: () async {
              final status = await widget.ticker.toggleFollow();
              if (status == 'full') {
                showWarningMsg(
                  context,
                  'Because of the API limit\nYou can only choose 5 stock to follow',
                );
              }
              setState(() {});
            },
            child: Container(
              alignment: Alignment.center,
              width: screenSize.width * 0.9,
              height: 50,
              decoration: BoxDecoration(
                border: widget.ticker.followed
                    ? null
                    : Border.all(color: Colors.grey[300]!),
                color: widget.ticker.followed ? Colors.blueGrey : Colors.white,
                borderRadius: BorderRadius.circular(10),
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
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'News',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SeeAllWidget(
                function: () {
                  widget.setScreen('news');
                },
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          // News section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final news in widget.ticker.newsList)
                    TickerNews(
                      news: news,
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

Widget _buildDefaultLineChart(Ticker currentTicker, String type) {
  if (currentTicker.prices[type] == null) {
    return Container();
  }
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(
      isVisible: false,
    ), // Initialize category axis.
    series: <LineSeries<Map<String, dynamic>, String>>[
      // Initialize line series.
      LineSeries<Map<String, dynamic>, String>(
        dataSource: [...currentTicker.prices[type]!],
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
