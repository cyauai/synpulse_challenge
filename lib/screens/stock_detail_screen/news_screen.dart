import 'package:flutter/material.dart';
import 'package:synpulse_challenge/models/stock.dart';
import 'package:synpulse_challenge/screens/stock_detail_screen/news_widget.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({
    Key? key,
    required this.setScreen,
    required this.ticker,
  }) : super(key: key);
  final Function setScreen;
  final Ticker ticker;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  setScreen('stock detail');
                },
                child: Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'News',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final news in ticker.newsList)
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
