import 'dart:convert';

import 'package:http/http.dart' as http;

const APIKEY_VANTAGE = 'M8EGV7V9H8YDSROH';
const APIKEY_TICKERINFO = '619e608d52ef38.00454342';
const stockTimeSeriesFunctionNames = {
  'intraDay': 'TIME_SERIES_INTRADAY',
  'daily': 'TIME_SERIES_DAILY_ADJUSTED',
  'monthly': 'TIME_SERIES_MONTHLY_ADJUSTED',
  'weekly': 'TIME_SERIES_WEEKLY_ADJUSTED',
  'all': 'TIME_SERIES_DAILY_ADJUSTED',
};

// format should be
// {
//  function
//  symbol
//  interval
// }
Future<dynamic> stockTimeSeriesApi(Map inputData) async {
  var url;

  if (inputData['type'] == 'intraday') {
    url = Uri.parse(
        'https://www.alphavantage.co/query?function=${inputData['function']}&symbol=${inputData['symbol']}&interval=${inputData['interval']}&apikey=$APIKEY_VANTAGE');
  } else if (inputData['type'] == 'all') {
    url = Uri.parse(
        'https://www.alphavantage.co/query?function=${inputData['function']}&symbol=${inputData['symbol']}&outputsize=${inputData['outputSize']}&apikey=$APIKEY_VANTAGE');
  } else {
    url = Uri.parse(
        'https://www.alphavantage.co/query?function=${inputData['function']}&symbol=${inputData['symbol']}&apikey=$APIKEY_VANTAGE');
  }
  final response = await http.get(url);
  return json.decode(response.body);
}

Future<dynamic> tickerListApi() async {
  var url = Uri.parse(
      'https://eodhistoricaldata.com/api/exchanges-list/?api_token=$APIKEY_TICKERINFO&fmt=json');
  final response = await http.get(url);
  return json.decode(response.body);
}

Future<dynamic> searchTickerApi(String keyword) async {
  var url = Uri.parse(
      'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$keyword&apikey=$APIKEY_VANTAGE');
  final response = await http.get(url);
  print(json.decode(response.body));
  return json.decode(response.body);
}
