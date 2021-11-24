import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:synpulse_challenge/models/stock.dart';

import '../../api_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockDetailScreen extends StatefulWidget {
  const StockDetailScreen({Key? key}) : super(key: key);

  @override
  _StockDetailScreenState createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  late Stock currentStock;

  @override
  void initState() {
    currentStock = Stock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextButton(
            child: Text("HI"),
            onPressed: () async {
              var url = Uri.parse(
                  'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=5min&apikey=$APIKEY');
              var response = await http.get(url);

              currentStock = Stock.fromJson(json.decode(response.body));
              setState(() {});
            },
          ),
          _buildDefaultLineChart(currentStock),
        ],
      ),
    );
  }
}

Widget _buildDefaultLineChart(Stock currentStock) {
  if (currentStock.symbol.isEmpty) {
    return Container();
  }
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(
      isVisible: false,
    ), // Initialize category axis.
    series: <LineSeries<Map<String, dynamic>, String>>[
      // Initialize line series.
      LineSeries<Map<String, dynamic>, String>(
        dataSource: [...currentStock.prices],
        xValueMapper: (Map<String, dynamic> price, _) => price.keys.first,
        yValueMapper: (Map<String, dynamic> price, _) => price.values.first,
      ),
    ],
  );
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
